Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp5-g21.free.fr ([212.27.42.5]:52219 "EHLO smtp5-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758436AbZFAVyj (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 1 Jun 2009 17:54:39 -0400
Received: from smtp5-g21.free.fr (localhost [127.0.0.1])
	by smtp5-g21.free.fr (Postfix) with ESMTP id B3C68D480AF
	for <linux-wireless@vger.kernel.org>; Mon,  1 Jun 2009 23:54:36 +0200 (CEST)
Received: from [192.168.1.189] (cac94-1-81-57-151-96.fbx.proxad.net [81.57.151.96])
	by smtp5-g21.free.fr (Postfix) with ESMTP id BF623D480FF
	for <linux-wireless@vger.kernel.org>; Mon,  1 Jun 2009 23:54:33 +0200 (CEST)
Message-ID: <4A244E19.7090501@free.fr>
Date: Mon, 01 Jun 2009 23:54:33 +0200
From: matthieu castet <castet.matthieu@free.fr>
MIME-Version: 1.0
To: linux-wireless@vger.kernel.org
Subject: b43 : unaligned access on mips
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

b43_generate_plcp_hdr generate unaligned access on mips with gcc [1] 
from openwrt.

A small testcase [2] show that &plcp->data is access as a 32 bit aligned 
variable (see the "lw      $2,0($4)" and "sw      $2,0($4)").
I don't know enough mips to know if it is a gcc bug (ignoring the packed 
attribute) or something missing in b43 code.


Matthieu



[1]
mipsel-openwrt-linux-uclibc-gcc -v
Using built-in specs.
Target: mipsel-openwrt-linux-uclibc
Configured with: 
/mnt/data/routeur/trunk/build_dir/toolchain-mipsel_gcc-4.1.2_uClibc-0.9.29/gcc-4.1.2/configure 
--prefix=/mnt/data/routeur/trunk/staging_dir/toolchain-mipsel_gcc-4.1.2_uClibc-0.9.29/usr 
--build=i486-linux-gnu --host=i486-linux-gnu 
--target=mipsel-openwrt-linux-uclibc --with-gnu-ld 
--enable-target-optspace --disable-libgomp --disable-libmudflap 
--disable-multilib --disable-nls --disable-libssp --disable-__cxa_atexit 
--enable-languages=c,c++ --enable-shared --enable-threads 
--with-slibdir=/mnt/data/routeur/trunk/staging_dir/toolchain-mipsel_gcc-4.1.2_uClibc-0.9.29/lib
Thread model: posix
gcc version 4.1.2

[2]
$cat test.c
#define __le32 unsigned int
#define u32 unsigned int
#define __u8 unsigned char
#define u8 unsigned char
#define u16 unsigned short
#define cpu_to_le32(x) (x)

#define _b43_declare_plcp_hdr(size) \
         struct b43_plcp_hdr##size {             \
                 union {                         \
                         __le32 data;            \
                         __u8 raw[size];         \
                 } __attribute__((__packed__));  \
         } __attribute__((__packed__))

/* struct b43_plcp_hdr4 */
_b43_declare_plcp_hdr(4);

void b43_generate_plcp_hdr(struct b43_plcp_hdr4 *plcp,
                                const u16 octets, const u8 bitrate)
{
                 u32 plen;
             __le32 *data = &(plcp->data);
                 plen = octets * 16 / bitrate;
                 *data |= cpu_to_le32(plen << 16);
}

$mipsel-openwrt-linux-uclibc-gcc test.c -Os -S
$cat test.s
         .file   1 "test.c"
         .section .mdebug.abi32
         .previous
         .abicalls
         .text
         .align  2
         .globl  b43_generate_plcp_hdr
         .ent    b43_generate_plcp_hdr
         .type   b43_generate_plcp_hdr, @function
b43_generate_plcp_hdr:
         .frame  $sp,0,$31               # vars= 0, regs= 0/0, args= 0, 
gp= 0
         .mask   0x00000000,0
         .fmask  0x00000000,0
         .set    noreorder
         .set    nomacro

         andi    $5,$5,0xffff
         sll     $5,$5,4
         andi    $6,$6,0x00ff
         bne     $6,$0,1f
         div     $0,$5,$6
         break   7
1:
         lw      $2,0($4)
         mflo    $5
         sll     $5,$5,16
         or      $2,$2,$5
         j       $31
         sw      $2,0($4)

         .set    macro
         .set    reorder
         .end    b43_generate_plcp_hdr
         .ident  "GCC: (GNU) 4.1.2"

Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from web55304.mail.re4.yahoo.com ([206.190.58.183]:25869 "HELO
	web55304.mail.re4.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1755946AbZFBDwM convert rfc822-to-8bit
	(ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 1 Jun 2009 23:52:12 -0400
Message-ID: <661650.46971.qm@web55304.mail.re4.yahoo.com>
Date: Mon, 1 Jun 2009 20:52:13 -0700 (PDT)
From: austinxxh-ath9k@yahoo.com
Reply-To: austinxxh-ath9k@yahoo.com
Subject: Re: ath9k/ath5k + 80211s crash
To: linux-wireless@vger.kernel.org, ath9k-devel@lists.ath9k.org,
	devel@lists.open80211s.org
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


Sorry, it should be "ath9k reboots, ath5k crashes, the dump log is for ath5k, while ath9k displayed nothing".

--- On Mon, 6/1/09, austinxxh-ath9k@yahoo.com <austinxxh-ath9k@yahoo.com> wrote:

> From: austinxxh-ath9k@yahoo.com <austinxxh-ath9k@yahoo.com>
> Subject: ath9k/ath5k + 80211s crash
> To: linux-wireless@vger.kernel.org, ath9k-devel@lists.ath9k.org, devel@lists.open80211s.org
> Date: Monday, June 1, 2009, 10:43 PM
> 
> Below is what I saw today(compat-wireless 2009-05-21), I
> have both an ath9k and an ath5k card. ath9k crashes (see
> below), ath5k will just reboot the board after "ifconfig
> mesh up", any idea?
> thanks,
> X Xiao
> 
> 
> BusyBox v1.13.4 (2009-06-01 21:18:32 CDT) built-in shell
> (ash)
> Enter 'help' for a list of built-in commands.
> 
>   _______           
>          ________   
>     __
>  |   
>    |.-----.-----.-----.|  | 
> |  |.----.|  |_
>  |   -   ||  _ 
> |  -__|     ||  | 
> |  ||   _||   _|
> 
> |_______||   __|_____|__|__||________||__| 
> |____|
>           |__| W I R E L E S
> S   F R E E D O M
>  KAMIKAZE (bleeding edge, r16290) -------------------
>   * 10 oz Vodka       Shake
> well with ice and strain
>   * 10 oz Triple sec  mixture into 10 shot
> glasses.
>   * 10 oz lime juice  Salute!
>  ---------------------------------------------------
> root@OpenWrt:/# iw dev wlan0 interface add mesh type mp
> mesh_id mesh
> root@OpenWrt:/# ifconfig -a | grep mesh
> mesh      Link encap:Ethernet  HWaddr
> 00:0B:6B:57:09:37  
> root@OpenWrt:/# ifconfig mesh up
> PCI error 1 at PCI addr 0x100109dc
> Data bus error, epc == c024f12c, ra == c024f128
> Oops[#1]:
> Cpu 0
> $ 0   : 00000000 00000000 deadc0de 000ffc00
> $ 4   : b00109dc b0010000 b0010000 0000000a
> $ 8   : 80170000 83aeaed0 00080000 00000000
> $12   : 00000000 839f04a8 802a0818 00000000
> $16   : 000009dc 8016b710 83aea000 000003ff
> $20   : 83aeaea8 8016b6bc 0000001c 00000007
> $24   : 00000000 80070000   
>               
> $28   : 82c5c000 82c5dc90 7fb0d068 c024f128
> Hi    : 000000d8
> Lo    : 00000144
> epc   : c024f12c 0xc024f12c
>     Not tainted
> ra    : c024f128 0xc024f128
> Status: 1000f403    KERNEL EXL IE 
> Cause : 1080001c
> PrId  : 00019374 (MIPS 24Kc)
> Modules linked in: nf_nat_tftp nf_conntrack_tftp nf_nat_irc
> nf_conntrack_irc nf_nat_ftp nf_conntrack_ftp i
> Process ifconfig (pid: 896, threadinfo=82c5c000,
> task=839f0000, tls=00000000)
> Stack : 83aea000 83a9d680 00000000 00000018 83aea000
> 83b109a0 83aea000 83aea000
>         00000300 83b101e0 82cddeb8
> 83b109a8 c025977c c0259700 ffffffff 00000000
>         00000002 00000000 00000003
> 00000000 00080000 00000000 00000000 00000000
>         00000000 00000000 00000000
> 00000000 00000001 83b109a0 82cddec0 c02599e0
>         00000000 c025a164 00000001
> 8009525c 82cddb80 00000300 83b101e0 82cdd800
>         ...
> Call Trace:[<c025977c>] 0xc025977c
> [<c0259700>] 0xc0259700
> [<c02599e0>] 0xc02599e0
> [<c025a164>] 0xc025a164
> [<8009525c>] 0x8009525c
> [<c01dcb64>] 0xc01dcb64
> [<c01ff3b8>] 0xc01ff3b8
> [<800dc19c>] 0x800dc19c
> [<c01eb4b0>] 0xc01eb4b0
> [<800b4040>] 0x800b4040
> [<801b85e8>] 0x801b85e8
> [<801b4454>] 0x801b4454
> [<800bdc94>] 0x800bdc94
> [<800bdc94>] 0x800bdc94
> [<801b632c>] 0x801b632c
> [<801b6b80>] 0x801b6b80
> [<801ffbf8>] 0x801ffbf8
> [<801ff9c8>] 0x801ff9c8
> [<801b75f8>] 0x801b75f8
> [<801b75ec>] 0x801b75ec
> [<801a75b8>] 0x801a75b8
> [<800e0890>] 0x800e0890
> [<800e0db0>] 0x800e0db0
> [<801a7e30>] 0x801a7e30
> [<800d5344>] 0x800d5344
> [<800d51c0>] 0x800d51c0
> [<801a7ebc>] 0x801a7ebc
> [<800e0e64>] 0x800e0e64
> [<80062504>] 0x80062504
> [<80062504>] 0x80062504
> 
> 
> Code: 02a0f809  02042021  8e450008
> <34440800> 0220f809  02052821 
> 8e440008  26c21100  3053fffc 
> Segmentation fault
> 
> _______________________________________________
> Devel mailing list
> Devel@lists.open80211s.org
> http://open80211s.com/mailman/listinfo/devel
> 

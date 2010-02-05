Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.bredband2.com ([83.219.192.166]:36003 "EHLO
	smtp.bredband2.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933863Ab0BEVwV (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 5 Feb 2010 16:52:21 -0500
Received: from [192.168.1.15] (c-94-255-223-183.cust.bredband2.com [94.255.223.183])
	(Authenticated sender: ed8153)
	by smtp.bredband2.com (Postfix) with ESMTPSA id C02C752407
	for <linux-wireless@vger.kernel.org>; Fri,  5 Feb 2010 22:46:02 +0100 (CET)
Message-ID: <4B6C9199.4080808@ludd.ltu.se>
Date: Fri, 05 Feb 2010 22:46:01 +0100
From: Benjamin Larsson <banan@ludd.ltu.se>
MIME-Version: 1.0
To: linux-wireless@vger.kernel.org
Subject: Marvell 88w8363 mwl8k
Content-Type: multipart/mixed;
 boundary="------------090609090003080100040703"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This is a multi-part message in MIME format.
--------------090609090003080100040703
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

Hi, I bought one of these cards:

http://cgi.ebay.com/Marvell-88W8363-300Mbps-802-11-B-G-N-Wireless-PCI-card_W0QQitemZ250537713404QQcmdZViewItemQQptZLH_DefaultDomain_0?hash=item3a55361efc

06:05.0 Ethernet controller [0200]: Marvell Technology Group Ltd. Device
[11ab:2a0a] (rev 03)

I tried to use it with the mwl8k driver from the
compat-wireless-2010-02-01 tree.

I had to add this to the mwl8k driver for it to pick up the card:

+	{ PCI_VDEVICE(MARVELL, 0x2a0a), .driver_data = MWL8363, },

Then the driver requested firmware images which where nowhere to be
found so I located a windows driver and extracted some firmware images
from it, I found 3 helper images and 4 firmware images in the windows
driver (it is named netmw145.sys). When looking at the helper images
they where all the same size so I guess those images are generic loader
images (they weren't the same though). Then I picked the biggest main
firmware image (fmimage_8XX1.fw) and tried to use it with the driver
(renamed it to fmimage_8363.fw). And like magic the interface went up.
Right now I'm able to use the 5k band with better speeds compared to
iw2200 on 2.4k band (~3 MB/s over ftp). The Marvell card was crap on the
2.4k band though (~.5 MB/s over ftp) compared to 2.2 MB/s with the iw2200.



Here are some md5sums to id the files I used.

a813c8c0dd58deab9472d8e3e7c0fb5b  netmw145.sys
48c79b085f7f5a590d3dbc15647e519f  fmimage_8XX0.fw
07fcb3fc7f2b4c7fbc78575796ea984b  fmimage_8XX1.fw
7c11600b8c3713105e6768dac1da81dc  fmimage_8XX2.fw
941d3f9f88b78fe38f4bf8bd9d24a728  fmimage_8XX3.fw
0fe11f415adbbd5e8ca03641705c4a6c  helper_8XX0.fw
ccbbe74ebfae9daecbd329cc818faaa3  helper_8XX1.fw
561e43b20532ae19e8bdea9e8f296ff0  helper_8XX2.fw


Attached is the program I used to extract the images from the windows
driver.

MvH
Benjamin Larsson

--------------090609090003080100040703
Content-Type: text/x-csrc;
 name="mrv8k_extract_fw.c"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="mrv8k_extract_fw.c"

/*
  
  Marvell Libertas wireless driver - tools

  Copyright (c) 2005 Luc Saillard <luc@saillard.org>

  This program is free software; you can redistribute it and/or modify
  it under the terms of the GNU General Public License as published by
  the Free Software Foundation; either version 2 of the License, or
  (at your option) any later version.

  This program is distributed in the hope that it will be useful,
  but WITHOUT ANY WARRANTY; without even the implied warranty of
  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
  GNU General Public License for more details.

  You should have received a copy of the GNU General Public License
  along with this program; see the file COPYING.  If not, write to
  the Free Software Foundation, Inc., 51 Franklin Steet, Fifth Floor,
  Boston, MA 02110-1301, USA.

  Build
    gcc -o mrv8k_extract_fw mrv8k_extract_fw.c -DUSE_OPENSSL -lcrypto
*/

#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <errno.h>
#include <math.h>

#include <sys/types.h>		/* for stat */
#include <sys/stat.h>
#include <unistd.h>

#include <sys/time.h>		/* for gettimeofday */
#include <time.h>

#include <sys/mman.h>		/* for mmap */
#include <fcntl.h>		/* for fcntl  */
#include <sys/select.h>		/* for select */

#ifdef USE_OPENSSL
#include <openssl/sha.h>
#endif

static const unsigned char *mmap_read_file(const char *filename, struct stat *sts);
static unsigned char* search_n_extract_firmware(const unsigned char *mem, size_t memlen, const char *filename);
static unsigned char* search_n_extract_bootloader(const unsigned char *mem, size_t memlen, const char *filename);
static unsigned char* search_mem32(const unsigned char *mem, size_t memlen,
 				const unsigned int *magic, size_t magiclen);

int main(int argc, char **argv)
{
  unsigned char* mem;
  unsigned char* pos;
  size_t memsize;
  unsigned char* memend;
  char fname[100];
  char bname[100];
  int i;
  struct stat sts;

  if (argc < 2) {
     fprintf(stderr, "%s: MRV8KAxx.sys\n", argv[0]);
     exit(1);
  }

  mem =(unsigned char*) mmap_read_file(argv[1], &sts);
  if (mem == NULL) {
     fprintf(stderr, "Can't mmap file %s\n", argv[1]);
     exit(1);
  }

//  printf("mem = %x\n",mem);
  memsize = sts.st_size;
  memend = mem+memsize;
  pos = mem;
  i = 0;
  
  while (pos && i < 6) {
    sprintf(bname,"helper_8XX%d.fw",i);
    pos = search_n_extract_bootloader(pos, memend-pos, bname);
    printf("pos = %x\n",pos-mem);
    i++;
  }

  pos = mem;
  i = 0;

  while (pos && i < 6) {
    sprintf(fname,"fmimage_8XX%d.fw",i);
    pos = search_n_extract_firmware(pos, memend-pos, fname);
    printf("pos = %x\n",pos-mem);
    i++;
  }

  munmap((void *)mem, memsize);
  
  return 0;
}

static const unsigned char *mmap_read_file(const char *filename, struct stat *sts)
{
  int fd;
  void *map;

  fd=open(filename,O_RDONLY);
  if (fd<0)
    goto error;
  if (fstat(fd,sts)<0)
    goto close_fd;

  map = mmap(0,sts->st_size,PROT_READ,MAP_PRIVATE,fd,0);
  if (map == MAP_FAILED)
    goto close_fd;
  close(fd);

  return map;

close_fd:
  close(fd);

error:
  fprintf(stderr, "Can't open file \"%s\"\n", filename);
  return NULL;
}

static int export_to_bin(const char *filename, const void *mem, size_t memlen, const unsigned char *sig)
{
#if USE_OPENSSL
  unsigned char md[SHA_DIGEST_LENGTH];
#endif
  FILE *f;

  f = fopen(filename,"w");
  if (f == NULL)
    return -1;
  fwrite(mem, memlen, 1, f);
  fclose(f);

#if USE_OPENSSL
  SHA1(mem, memlen, md);
  if (memcmp(md, sig, SHA_DIGEST_LENGTH)) {
     printf("Warning: Bad signature for the firmware\n");
     printf("got    %.2x%.2x%.2x%.2x%.2x%.2x%.2x%.2x%.2x%.2x%.2x%.2x%.2x%.2x%.2x%.2x%.2x%.2x%.2x%.2x\n",
	 md[0], md[1], md[2], md[3], md[4], md[5], md[6], md[7], md[8], md[9],
	 md[10], md[11], md[12], md[13], md[14], md[15], md[16], md[17], md[18], md[19]);
     printf("wanted %.2x%.2x%.2x%.2x%.2x%.2x%.2x%.2x%.2x%.2x%.2x%.2x%.2x%.2x%.2x%.2x%.2x%.2x%.2x%.2x\n",
	 sig[0], sig[1], sig[2], sig[3], sig[4], sig[5], sig[6], sig[7], sig[8], sig[9],
	 sig[10], sig[11], sig[12], sig[13], sig[14], sig[15], sig[16], sig[17], sig[18], sig[19]);
  }
#endif

  return 0;
}

static unsigned char* search_mem32(const unsigned char *mem, size_t memlen,
 				const unsigned int *magic, size_t magiclen)
{
  int i=0;
  unsigned int* memp = (unsigned int*)mem;

  if (magiclen&4)	/* We search using a 32 bit pointer */
    return NULL;

  memlen   = memlen/4;
  magiclen = magiclen/4;

  while (--memlen) {
     if (magic[i] == *memp) {
	i++;
	if (i == magiclen)
	  return (unsigned char*)(memp-i+1);
     } else {
	i = 0;
     }
     memp++;
  }
  return NULL;
}


struct fw {
   char *driver_name;
   char *driver_version;
   unsigned int  main_size;
   unsigned char boot_sig[20];
   unsigned char main_sig[20];
} list_of_fw[] = {
    {
      "ASUS WL-138G", "2.3.0.19", 0x2DF00,
      {
	0x6e, 0x05, 0xab, 0xc8, 0xc4, 0xb2, 0x59, 0x7e, 0x1d, 0xad,
	0x63, 0xb0, 0xa1, 0xbb, 0x8d, 0x45, 0xd5, 0xe3, 0x29, 0xee
      },
      {
	0xa9, 0x4d, 0x98, 0xf1, 0xe7, 0x67, 0xa4, 0x13, 0xec, 0x8a,
	0xc6, 0xe7, 0x68, 0x87, 0xd8, 0x92, 0xfd, 0xce, 0x9c, 0x4f
      }
    },
    {
      "PLANET WL-3563", "2.3.0.3", 0x2DF00,
      {
	0x6e, 0x05, 0xab, 0xc8, 0xc4, 0xb2, 0x59, 0x7e, 0x1d, 0xad,
	0x63, 0xb0, 0xa1, 0xbb, 0x8d, 0x45, 0xd5, 0xe3, 0x29, 0xee
      },
      {
	0x4b, 0x4c, 0x67, 0x38, 0x81, 0x9f, 0x63, 0xfd, 0x3f, 0x32,
	0x48, 0xc4, 0x08, 0xc7, 0xa6, 0x17, 0x09, 0xbf, 0x1f, 0x3e,
      }
    },
    {
      "NETGEAR WG311v3", "3.1.1.7", 0x1df00,
      {

      },
      {

      }
    }
};


static unsigned char* search_n_extract_bootloader(const unsigned char *mem, size_t memlen, const char *filename)
{
  unsigned char *result = NULL;
  unsigned char *result_end_marker = NULL;

  static unsigned int bootloader_magic[] = {
     0xEA000003, 0x05, 0x0, 0x0
  };

  static unsigned int bootloader_end_marker[] = {
     0x0C0000629, 0x0C0000669, 0x4001000, 0x0
  };


  result = search_mem32(mem, memlen, bootloader_magic, sizeof(bootloader_magic));
  if (!result) {
     printf("Bootloader not found\n");
     return NULL;
  }

  result_end_marker = search_mem32(mem, memlen, bootloader_end_marker, sizeof(bootloader_end_marker));
  if (!result_end_marker) {
     printf("Bootloader end marker not found\n");
     return NULL;
  }


  printf("Bootloader signature found at %ld\n", (long)(result-mem));
  export_to_bin(filename, result, (result_end_marker+sizeof(bootloader_end_marker))-result, list_of_fw[0].main_sig);
  return result_end_marker+sizeof(bootloader_end_marker);
}

static unsigned char* search_n_extract_firmware(const unsigned char *mem, size_t memlen, const char *filename)
{
  unsigned long offset, len;
  unsigned char *result = NULL;
  unsigned char *result_end_marker = NULL;
  static unsigned int firmware_magic[] = {
     0xE59FF018, 0xE59FF018, 0xE59FF018, 0xE59FF018,
     0xE59FF018, 0xE59FF018, 0xE59FF018, 0xE59FF018
  };

  static unsigned int firmware_end_marker[] = {
     0x4,0x0,0x0,0x188CDB1F,
  };


  result = search_mem32(mem, memlen, firmware_magic, sizeof(firmware_magic));
  if (!result) {
     printf("Firmware not found\n");
     return NULL;
  }

  result_end_marker = search_mem32(mem, memlen, firmware_end_marker, sizeof(firmware_end_marker));
  if (!result_end_marker) {
     printf("Firmware end marker not found\n");
     return NULL;
  }

  offset = (unsigned long)(result-mem);
  printf("Firmware found at %ld\n", offset);

  export_to_bin(filename, result-16, (result_end_marker+sizeof(firmware_end_marker))-(result-16), list_of_fw[0].main_sig);
  return result_end_marker+sizeof(firmware_end_marker);
}



--------------090609090003080100040703--

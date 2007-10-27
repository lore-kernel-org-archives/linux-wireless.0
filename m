Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from py-out-1112.google.com ([64.233.166.176]:61198 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750716AbXJ0V5N (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 27 Oct 2007 17:57:13 -0400
Received: by py-out-1112.google.com with SMTP id u77so2101687pyb
        for <linux-wireless@vger.kernel.org>; Sat, 27 Oct 2007 14:57:12 -0700 (PDT)
Message-ID: <40f31dec0710271457u4636126bsacd654e017806c6a@mail.gmail.com> (sfid-20071027_225718_831529_7FA997D3)
Date: Sun, 28 Oct 2007 00:57:11 +0300
From: "Nick Kossifidis" <mickflemm@gmail.com>
To: "Dan Williams" <dcbw@redhat.com>
Subject: Re: AR5418 abgn part?
Cc: linux-wireless@vger.kernel.org, ath5k-devel@lists.ath5k.org,
	"Luis R. Rodriguez" <mcgrof@gmail.com>,
	"Jiri Slaby" <jirislaby@gmail.com>
In-Reply-To: <1192808570.6104.11.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
References: <1192808570.6104.11.camel@localhost.localdomain>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

2007/10/19, Dan Williams <dcbw@redhat.com>:
> Anyone working on this part or is there just not enough bandwidth?  It's
> completely unrecognized with fairly recent wireless-everything.  I've
> got a machine with one here, would be happy to test stuff if there's
> anything to test.
>
> Dan
>

I got a macbook pro and working on it, so far i've managed ro read the
new EEPROM and locate regulatory domain but it needs a lot of work to
be done...

EEPROM of 5418 (and i believe 5416 also) differs a lot from the
previous versions. On this one you'll have to read register 0x2000 +
(2* offset) to set offset and then read 0x0407c some times to get the
data, here is a sample regdump while reading the magic value (it's
being swapped for some reason, instead of 5aa5 is a55a )...

W:0x09880 = 0x00010000 - unknown
W:0x09880 = 0x00010000 - unknown
W:0x09880 = 0x00010000 - unknown
W:0x09880 = 0x00010000 - unknown
R:0x09c00 = 0x30000000 - unknown
R:0x02000 = 0xbadc0ffe - unknown
R:0x0407c = 0x00010000 - unknown
R:0x0407c = 0x00010000 - unknown
R:0x0407c = 0x00010000 - unknown
R:0x0407c = 0x00010000 - unknown
R:0x0407c = 0x0000a55a - unknown
R:0x0407c = 0x0000a55a - unknown
R:0x02400 = 0xbadc0ffe - unknown
R:0x0407c = 0x0001a55a - unknown
R:0x0407c = 0x0001a55a - unknown
R:0x0407c = 0x0001a55a - unknown
R:0x0407c = 0x0001a55a - unknown
R:0x0407c = 0x00000cb8 - unknown
R:0x0407c = 0x00000cb8 - unknown

note that 0x2000 + 2* offset returns 0xbadc0ffe if offset is ok and
0xffff... when offset is invalid (in that situation 0x0407c returns
previous reading).

Also here is a sample function to read the EEPROM...

int
ath5k_hw_eeprom_read(void *mem, u_int32_t offset, u_int16_t *data,
               u_int8_t mac_version)
{
       u_int32_t tmp;
       int i;

       tmp = AR5K_REG_READ(0x2000 + (2 * (offset)));
       if(tmp != 0xbadc0ffe){
               printf("Invalid Offset\n");
               return -1;
       }
       for(i=0;i<7;i++){
               usleep(10);
               tmp = (u_int16_t) AR5K_REG_READ(0x0407c);
/* This looks sane according to regdump but when i try it from
   userspace it won't work */
//              if(tmp & 0x00010000){
//                      continue;
//              } else {
//                      break;
//              }
       }
/* I used this to swap data when i saw the magic number
  being swapped, it seems though that rest of eeprom data
  is ok. */
//      tmp = (tmp << 8) | (tmp >> 8);
       printf("EEPROM READ: 0x%x 0x%x\n",offset,tmp);
       *data = tmp;
       return 0;
}

Also offsets have changed, i was only able to locate regdomain offset
(0x208) and i believe eeprom's version (0x06 - that reads 6000 in my
case and having in mind that previous eeproms had version 5.3 it
looked a sane value to me), i'm still searching for the header (if
such thing exists) and rest infos. Also note that huge parts of eeprom
re only 0s or Fs (probably reserved for future use or something).


-- 
GPG ID: 0xD21DB2DB
As you read this post global entropy rises. Have Fun ;-)
Nick

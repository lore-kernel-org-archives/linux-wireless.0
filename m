Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ug-out-1314.google.com ([66.249.92.172]:38327 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756283AbYEBVWr (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 2 May 2008 17:22:47 -0400
Received: by ug-out-1314.google.com with SMTP id h3so147222ugf.16
        for <linux-wireless@vger.kernel.org>; Fri, 02 May 2008 14:22:45 -0700 (PDT)
To: Johannes Berg <johannes@sipsolutions.net>
Subject: Re: rt61pci/rt73usb: Hardware decryption IV/EIV
Date: Fri, 2 May 2008 23:28:00 +0200
Cc: linux-wireless@vger.kernel.org, rt2400-devel@lists.sourceforge.net
References: <200805022141.28351.IvDoorn@gmail.com> <200805022259.20118.IvDoorn@gmail.com> <1209762178.3608.21.camel@johannes.berg>
In-Reply-To: <1209762178.3608.21.camel@johannes.berg>
MIME-Version: 1.0
Content-Type: Multipart/Mixed;
  boundary="Boundary-00=_gd4GIcyf2u6+H2C"
Message-Id: <200805022328.00185.IvDoorn@gmail.com> (sfid-20080502_232224_790545_5BE972A2)
From: Ivo van Doorn <ivdoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

--Boundary-00=_gd4GIcyf2u6+H2C
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

On Friday 02 May 2008, Johannes Berg wrote:
> On Fri, 2008-05-02 at 22:59 +0200, Ivo van Doorn wrote:
> > On Friday 02 May 2008, Johannes Berg wrote:
> > > 
> > > > Now there you mention something. Looking at the Legacy driver, they only mention
> > > > ICV during the TX, but never during RX. I did find that the MMIC is appended at the
> > > > end of the frame, which is good, but they never do anything that looks like the
> > > > stripping of the ICV data...
> > > > So I assume it is stripped in the hardware, but no descriptor definition indicates
> > > > a ICV field like there is for IV and EIV. Unless.... they do have a 32bits "reserved" field
> > > > located directly after the IV/EIV fields.. makes one curious if that accidently contains ICV data. ;)
> > > 
> > > Heh. Maybe the hardware actually does replay protection so it doesn't
> > > matter?
> > 
> > The comments in the legacy driver indicates the IV/EIV data was provided for replay attack checking,
> > and I do see a lot of ReplayCounters being memcpy'ed and memcmp() in the driver.
> > What is missing is the intialization of those counters to anything other then 0, and
> > the actual usage of the IV/EIV data in the Rx descriptor. ;)
> 
> Heh. Actually, yes, if the device does ICV checking then replay
> detection can be easily done in software w/o the ICV, but mac80211
> doesn't support that. You could probably just implement it in the driver
> though.

Well the ICV is checked in the hardware,
the hardware has the following RX status messages:
	RX_CRYPTO_SUCCESS = 0,
	RX_CRYPTO_FAIL_ICV = 1,
	RX_CRYPTO_FAIL_MIC = 2,
	RX_CRYPTO_FAIL_KEY = 3,

I have added the following debugline to rt2x00 for all frames which the insert IV routine is running:
			printk(KERN_DEBUG "RX: fc: %04x, sc: %04x, a1: %s, a2: %s, a3: %s\n",
				hdr->frame_control, hdr->seq_ctrl,
				print_mac(addr1, hdr->addr1),
				print_mac(addr2, hdr->addr2),
				print_mac(addr3, hdr->addr3));

*however* with the "reserved" descriptor field added to the tail of the frame,
made the device come to live again. The rx_handlers_drop counter now stays at the
usual level of 3, and pings are getting through.
I haven't checked if the descriptor field actually contains any data, but then again
mac80211 doesn't check the value either (with WEP anyway). ;)
So either the descriptor field is indeed the ICV,
or just appending 4 random bytes at the end of the frame did the trick.
Somehow I think the second idea has the highest probability. :S

Ivo

--Boundary-00=_gd4GIcyf2u6+H2C
Content-Type: text/plain;
  charset="iso-8859-15";
  name="log"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename="log"

May  2 23:07:27 localhost RX: fc: 4208, sc: 6f50, a1: 00:0c:f6:1e:43:4c, a2: 00:16:b6:12:5e:5c, a3: 00:16:b6:12:5e:5c
May  2 23:07:29 localhost RX: fc: 4208, sc: 70e0, a1: ff:ff:ff:ff:ff:ff, a2: 00:16:b6:12:5e:5c, a3: 00:0e:a6:7f:0b:56
May  2 23:07:31 localhost RX: fc: 4208, sc: 7330, a1: ff:ff:ff:ff:ff:ff, a2: 00:16:b6:12:5e:5c, a3: 00:16:b6:12:5e:5c
May  2 23:07:31 localhost RX: fc: 4208, sc: 73d0, a1: ff:ff:ff:ff:ff:ff, a2: 00:16:b6:12:5e:5c, a3: 00:16:b6:12:5e:5c
May  2 23:07:31 localhost RX: fc: 4208, sc: 7410, a1: ff:ff:ff:ff:ff:ff, a2: 00:16:b6:12:5e:5c, a3: 00:16:b6:12:5e:5c
May  2 23:07:31 localhost RX: fc: 4208, sc: 7420, a1: ff:ff:ff:ff:ff:ff, a2: 00:16:b6:12:5e:5c, a3: 00:16:b6:12:5e:5c
May  2 23:07:31 localhost RX: fc: 4208, sc: 7550, a1: ff:ff:ff:ff:ff:ff, a2: 00:16:b6:12:5e:5c, a3: 00:16:b6:12:5e:5c
May  2 23:07:31 localhost RX: fc: 4208, sc: 7580, a1: ff:ff:ff:ff:ff:ff, a2: 00:16:b6:12:5e:5c, a3: 00:16:b6:12:5e:5c
May  2 23:07:31 localhost RX: fc: 4208, sc: 75b0, a1: ff:ff:ff:ff:ff:ff, a2: 00:16:b6:12:5e:5c, a3: 00:16:b6:12:5e:5c
May  2 23:07:35 localhost RX: fc: 4208, sc: 79a0, a1: 01:00:5e:7f:ff:fa, a2: 00:16:b6:12:5e:5c, a3: 00:16:b6:12:5e:5c
May  2 23:07:35 localhost RX: fc: 4208, sc: 79b0, a1: 01:00:5e:7f:ff:fa, a2: 00:16:b6:12:5e:5c, a3: 00:16:b6:12:5e:5c
May  2 23:07:35 localhost RX: fc: 4208, sc: 79c0, a1: 01:00:5e:7f:ff:fa, a2: 00:16:b6:12:5e:5c, a3: 00:16:b6:12:5e:5c
May  2 23:07:35 localhost RX: fc: 4208, sc: 79d0, a1: 01:00:5e:7f:ff:fa, a2: 00:16:b6:12:5e:5c, a3: 00:16:b6:12:5e:5c
May  2 23:07:35 localhost RX: fc: 4208, sc: 79e0, a1: 01:00:5e:7f:ff:fa, a2: 00:16:b6:12:5e:5c, a3: 00:16:b6:12:5e:5c
May  2 23:07:35 localhost RX: fc: 4208, sc: 79f0, a1: 01:00:5e:7f:ff:fa, a2: 00:16:b6:12:5e:5c, a3: 00:16:b6:12:5e:5c
May  2 23:07:35 localhost RX: fc: 4208, sc: 7a00, a1: 01:00:5e:7f:ff:fa, a2: 00:16:b6:12:5e:5c, a3: 00:16:b6:12:5e:5c
May  2 23:07:35 localhost RX: fc: 4208, sc: 7a10, a1: 01:00:5e:7f:ff:fa, a2: 00:16:b6:12:5e:5c, a3: 00:16:b6:12:5e:5c
May  2 23:07:35 localhost RX: fc: 4208, sc: 7a20, a1: 01:00:5e:7f:ff:fa, a2: 00:16:b6:12:5e:5c, a3: 00:16:b6:12:5e:5c
May  2 23:07:35 localhost RX: fc: 4208, sc: 7a30, a1: 01:00:5e:7f:ff:fa, a2: 00:16:b6:12:5e:5c, a3: 00:16:b6:12:5e:5c
May  2 23:07:37 localhost RX: fc: 4208, sc: 7b80, a1: ff:ff:ff:ff:ff:ff, a2: 00:16:b6:12:5e:5c, a3: 00:16:b6:12:5e:5c
May  2 23:07:37 localhost RX: fc: 4208, sc: 7b90, a1: 00:0c:f6:1e:43:4c, a2: 00:16:b6:12:5e:5c, a3: 00:16:b6:12:5e:5c
May  2 23:07:37 localhost RX: fc: 4208, sc: 7ba0, a1: 00:0c:f6:1e:43:4c, a2: 00:16:b6:12:5e:5c, a3: 00:16:b6:12:5e:5c
May  2 23:07:37 localhost RX: fc: 4208, sc: 7bb0, a1: ff:ff:ff:ff:ff:ff, a2: 00:16:b6:12:5e:5c, a3: 00:16:b6:12:5e:5c
May  2 23:07:37 localhost RX: fc: 4208, sc: 7bc0, a1: ff:ff:ff:ff:ff:ff, a2: 00:16:b6:12:5e:5c, a3: 00:16:b6:12:5e:5c
May  2 23:07:37 localhost RX: fc: 4208, sc: 7bd0, a1: 00:0c:f6:1e:43:4c, a2: 00:16:b6:12:5e:5c, a3: 00:16:b6:12:5e:5c
May  2 23:07:38 localhost RX: fc: 4208, sc: 7ca0, a1: ff:ff:ff:ff:ff:ff, a2: 00:16:b6:12:5e:5c, a3: 00:16:b6:12:5e:5c
May  2 23:07:38 localhost RX: fc: 4208, sc: 7cb0, a1: 00:0c:f6:1e:43:4c, a2: 00:16:b6:12:5e:5c, a3: 00:16:b6:12:5e:5c
May  2 23:07:38 localhost RX: fc: 4208, sc: 7cc0, a1: 00:0c:f6:1e:43:4c, a2: 00:16:b6:12:5e:5c, a3: 00:16:b6:12:5e:5c
May  2 23:07:38 localhost RX: fc: 4208, sc: 7cd0, a1: ff:ff:ff:ff:ff:ff, a2: 00:16:b6:12:5e:5c, a3: 00:16:b6:12:5e:5c
May  2 23:07:39 localhost RX: fc: 4208, sc: 7d90, a1: ff:ff:ff:ff:ff:ff, a2: 00:16:b6:12:5e:5c, a3: 00:16:b6:12:5e:5c
May  2 23:07:39 localhost RX: fc: 4208, sc: 7da0, a1: 00:0c:f6:1e:43:4c, a2: 00:16:b6:12:5e:5c, a3: 00:16:b6:12:5e:5c
May  2 23:07:39 localhost RX: fc: 4208, sc: 7db0, a1: ff:ff:ff:ff:ff:ff, a2: 00:16:b6:12:5e:5c, a3: 00:16:b6:12:5e:5c
May  2 23:07:39 localhost RX: fc: 4208, sc: 7dc0, a1: 00:0c:f6:1e:43:4c, a2: 00:16:b6:12:5e:5c, a3: 00:16:b6:12:5e:5c
May  2 23:07:40 localhost RX: fc: 4208, sc: 80a0, a1: ff:ff:ff:ff:ff:ff, a2: 00:16:b6:12:5e:5c, a3: 00:16:b6:12:5e:5c
May  2 23:07:40 localhost RX: fc: 4208, sc: 80d0, a1: ff:ff:ff:ff:ff:ff, a2: 00:16:b6:12:5e:5c, a3: 00:16:b6:12:5e:5c
May  2 23:07:40 localhost RX: fc: 4208, sc: 80f0, a1: 00:0c:f6:1e:43:4c, a2: 00:16:b6:12:5e:5c, a3: 00:16:b6:12:5e:5c
May  2 23:07:40 localhost RX: fc: 4208, sc: 8100, a1: ff:ff:ff:ff:ff:ff, a2: 00:16:b6:12:5e:5c, a3: 00:16:b6:12:5e:5c
May  2 23:07:40 localhost RX: fc: 4208, sc: 8110, a1: 00:0c:f6:1e:43:4c, a2: 00:16:b6:12:5e:5c, a3: 00:16:b6:12:5e:5c
May  2 23:07:40 localhost RX: fc: 4208, sc: 81f0, a1: ff:ff:ff:ff:ff:ff, a2: 00:16:b6:12:5e:5c, a3: 00:16:b6:12:5e:5c
May  2 23:07:40 localhost RX: fc: 4208, sc: 8200, a1: ff:ff:ff:ff:ff:ff, a2: 00:16:b6:12:5e:5c, a3: 00:16:b6:12:5e:5c
May  2 23:07:40 localhost RX: fc: 4208, sc: 8210, a1: ff:ff:ff:ff:ff:ff, a2: 00:16:b6:12:5e:5c, a3: 00:16:b6:12:5e:5c
May  2 23:07:41 localhost RX: fc: 4208, sc: 8390, a1: ff:ff:ff:ff:ff:ff, a2: 00:16:b6:12:5e:5c, a3: 00:16:b6:12:5e:5c
May  2 23:07:41 localhost RX: fc: 4208, sc: 83b0, a1: ff:ff:ff:ff:ff:ff, a2: 00:16:b6:12:5e:5c, a3: 00:16:b6:12:5e:5c
May  2 23:07:41 localhost RX: fc: 4208, sc: 8430, a1: ff:ff:ff:ff:ff:ff, a2: 00:16:b6:12:5e:5c, a3: 00:16:b6:12:5e:5c
May  2 23:07:41 localhost RX: fc: 4208, sc: 8440, a1: 00:0c:f6:1e:43:4c, a2: 00:16:b6:12:5e:5c, a3: 00:16:b6:12:5e:5c
May  2 23:07:41 localhost RX: fc: 4208, sc: 8460, a1: ff:ff:ff:ff:ff:ff, a2: 00:16:b6:12:5e:5c, a3: 00:16:b6:12:5e:5c
May  2 23:07:41 localhost RX: fc: 4208, sc: 8480, a1: 00:0c:f6:1e:43:4c, a2: 00:16:b6:12:5e:5c, a3: 00:16:b6:12:5e:5c
May  2 23:07:42 localhost RX: fc: 4208, sc: 86e0, a1: ff:ff:ff:ff:ff:ff, a2: 00:16:b6:12:5e:5c, a3: 00:16:b6:12:5e:5c
May  2 23:07:42 localhost RX: fc: 4208, sc: 86f0, a1: 00:0c:f6:1e:43:4c, a2: 00:16:b6:12:5e:5c, a3: 00:16:b6:12:5e:5c
May  2 23:07:42 localhost RX: fc: 4208, sc: 8700, a1: ff:ff:ff:ff:ff:ff, a2: 00:16:b6:12:5e:5c, a3: 00:16:b6:12:5e:5c
May  2 23:07:42 localhost RX: fc: 4208, sc: 8710, a1: 00:0c:f6:1e:43:4c, a2: 00:16:b6:12:5e:5c, a3: 00:16:b6:12:5e:5c
May  2 23:07:43 localhost RX: fc: 4208, sc: 87c0, a1: ff:ff:ff:ff:ff:ff, a2: 00:16:b6:12:5e:5c, a3: 00:16:b6:12:5e:5c
May  2 23:07:43 localhost RX: fc: 4208, sc: 87d0, a1: 00:0c:f6:1e:43:4c, a2: 00:16:b6:12:5e:5c, a3: 00:16:b6:12:5e:5c
May  2 23:07:43 localhost RX: fc: 4208, sc: 87e0, a1: ff:ff:ff:ff:ff:ff, a2: 00:16:b6:12:5e:5c, a3: 00:16:b6:12:5e:5c
May  2 23:07:43 localhost RX: fc: 4208, sc: 87f0, a1: 00:0c:f6:1e:43:4c, a2: 00:16:b6:12:5e:5c, a3: 00:16:b6:12:5e:5c
May  2 23:07:48 localhost RX: fc: 4208, sc: 8c60, a1: ff:ff:ff:ff:ff:ff, a2: 00:16:b6:12:5e:5c, a3: 00:16:b6:12:5e:5c
May  2 23:07:53 localhost RX: fc: 4208, sc: 8f90, a1: 00:0c:f6:1e:43:4c, a2: 00:16:b6:12:5e:5c, a3: 00:16:b6:12:5e:5c
May  2 23:07:53 localhost RX: fc: 4208, sc: 8fa0, a1: ff:ff:ff:ff:ff:ff, a2: 00:16:b6:12:5e:5c, a3: 00:16:b6:12:5e:5c
May  2 23:07:53 localhost RX: fc: 4208, sc: 8fb0, a1: 00:0c:f6:1e:43:4c, a2: 00:16:b6:12:5e:5c, a3: 00:16:b6:12:5e:5c
May  2 23:07:53 localhost RX: fc: 4208, sc: 8fc0, a1: ff:ff:ff:ff:ff:ff, a2: 00:16:b6:12:5e:5c, a3: 00:16:b6:12:5e:5c
May  2 23:07:53 localhost RX: fc: 4208, sc: 8fd0, a1: 00:0c:f6:1e:43:4c, a2: 00:16:b6:12:5e:5c, a3: 00:16:b6:12:5e:5c
May  2 23:07:54 localhost RX: fc: 4208, sc: 9090, a1: ff:ff:ff:ff:ff:ff, a2: 00:16:b6:12:5e:5c, a3: 00:16:b6:12:5e:5c
May  2 23:07:54 localhost RX: fc: 4208, sc: 90a0, a1: 00:0c:f6:1e:43:4c, a2: 00:16:b6:12:5e:5c, a3: 00:16:b6:12:5e:5c
May  2 23:07:54 localhost RX: fc: 4208, sc: 90b0, a1: ff:ff:ff:ff:ff:ff, a2: 00:16:b6:12:5e:5c, a3: 00:16:b6:12:5e:5c
May  2 23:07:54 localhost RX: fc: 4208, sc: 90c0, a1: 00:0c:f6:1e:43:4c, a2: 00:16:b6:12:5e:5c, a3: 00:16:b6:12:5e:5c
May  2 23:07:55 localhost RX: fc: 4208, sc: 9170, a1: ff:ff:ff:ff:ff:ff, a2: 00:16:b6:12:5e:5c, a3: 00:16:b6:12:5e:5c
May  2 23:07:55 localhost RX: fc: 4208, sc: 9180, a1: 00:0c:f6:1e:43:4c, a2: 00:16:b6:12:5e:5c, a3: 00:16:b6:12:5e:5c
May  2 23:07:55 localhost RX: fc: 4208, sc: 9190, a1: ff:ff:ff:ff:ff:ff, a2: 00:16:b6:12:5e:5c, a3: 00:16:b6:12:5e:5c
May  2 23:07:55 localhost RX: fc: 4208, sc: 91a0, a1: 00:0c:f6:1e:43:4c, a2: 00:16:b6:12:5e:5c, a3: 00:16:b6:12:5e:5c
May  2 23:07:56 localhost RX: fc: 4208, sc: 9250, a1: ff:ff:ff:ff:ff:ff, a2: 00:16:b6:12:5e:5c, a3: 00:16:b6:12:5e:5c
May  2 23:07:56 localhost RX: fc: 4208, sc: 9260, a1: 00:0c:f6:1e:43:4c, a2: 00:16:b6:12:5e:5c, a3: 00:16:b6:12:5e:5c
May  2 23:07:56 localhost RX: fc: 4208, sc: 9280, a1: ff:ff:ff:ff:ff:ff, a2: 00:16:b6:12:5e:5c, a3: 00:16:b6:12:5e:5c
May  2 23:07:56 localhost RX: fc: 4208, sc: 9290, a1: 00:0c:f6:1e:43:4c, a2: 00:16:b6:12:5e:5c, a3: 00:16:b6:12:5e:5c
May  2 23:07:57 localhost RX: fc: 4208, sc: 9330, a1: ff:ff:ff:ff:ff:ff, a2: 00:16:b6:12:5e:5c, a3: 00:16:b6:12:5e:5c
May  2 23:07:57 localhost RX: fc: 4208, sc: 9340, a1: 00:0c:f6:1e:43:4c, a2: 00:16:b6:12:5e:5c, a3: 00:16:b6:12:5e:5c
May  2 23:07:57 localhost RX: fc: 4208, sc: 9350, a1: ff:ff:ff:ff:ff:ff, a2: 00:16:b6:12:5e:5c, a3: 00:16:b6:12:5e:5c
May  2 23:07:57 localhost RX: fc: 4208, sc: 9360, a1: 00:0c:f6:1e:43:4c, a2: 00:16:b6:12:5e:5c, a3: 00:16:b6:12:5e:5c
May  2 23:07:58 localhost RX: fc: 4208, sc: 9410, a1: ff:ff:ff:ff:ff:ff, a2: 00:16:b6:12:5e:5c, a3: 00:16:b6:12:5e:5c
May  2 23:07:58 localhost RX: fc: 4208, sc: 9420, a1: 00:0c:f6:1e:43:4c, a2: 00:16:b6:12:5e:5c, a3: 00:16:b6:12:5e:5c
May  2 23:07:58 localhost RX: fc: 4208, sc: 9430, a1: ff:ff:ff:ff:ff:ff, a2: 00:16:b6:12:5e:5c, a3: 00:16:b6:12:5e:5c
May  2 23:07:58 localhost RX: fc: 4208, sc: 9440, a1: 00:0c:f6:1e:43:4c, a2: 00:16:b6:12:5e:5c, a3: 00:16:b6:12:5e:5c
May  2 23:07:59 localhost RX: fc: 4208, sc: 94f0, a1: ff:ff:ff:ff:ff:ff, a2: 00:16:b6:12:5e:5c, a3: 00:16:b6:12:5e:5c
May  2 23:07:59 localhost RX: fc: 4208, sc: 9500, a1: 00:0c:f6:1e:43:4c, a2: 00:16:b6:12:5e:5c, a3: 00:16:b6:12:5e:5c
May  2 23:07:59 localhost RX: fc: 4208, sc: 9510, a1: ff:ff:ff:ff:ff:ff, a2: 00:16:b6:12:5e:5c, a3: 00:16:b6:12:5e:5c
May  2 23:07:59 localhost RX: fc: 4208, sc: 9520, a1: 00:0c:f6:1e:43:4c, a2: 00:16:b6:12:5e:5c, a3: 00:16:b6:12:5e:5c
May  2 23:08:04 localhost RX: fc: 4208, sc: 9840, a1: ff:ff:ff:ff:ff:ff, a2: 00:16:b6:12:5e:5c, a3: 00:16:b6:12:5e:5c
May  2 23:08:09 localhost RX: fc: 4208, sc: 9b60, a1: 00:0c:f6:1e:43:4c, a2: 00:16:b6:12:5e:5c, a3: 00:16:b6:12:5e:5c 

--Boundary-00=_gd4GIcyf2u6+H2C--

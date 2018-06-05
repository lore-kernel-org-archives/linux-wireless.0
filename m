Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from esa4.microchip.iphmx.com ([68.232.154.123]:3865 "EHLO
        esa4.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751653AbeFEL2C (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 5 Jun 2018 07:28:02 -0400
Date: Tue, 5 Jun 2018 11:42:20 +0530
From: Ajay Singh <ajay.kathat@microchip.com>
To: Thibaut Robert <thibaut.robert@gmail.com>
CC: Dan Carpenter <dan.carpenter@oracle.com>,
        <devel@driverdev.osuosl.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        <linux-wireless@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        "Ganesh Krishna" <ganesh.krishna@microchip.com>,
        Aditya Shankar <aditya.shankar@microchip.com>
Subject: Re: [PATCH 1/2] staging: wilc1000: fix some endianness sparse
 warnings
Message-ID: <20180605114220.5a893f01@ajaysk-VirtualBox> (sfid-20180605_132817_314322_BEC92763)
In-Reply-To: <20180605083325.GA6965@L80496>
References: <20180529191143.13081-1-thibaut.robert@gmail.com>
        <20180530111725.gmigyddsp2i6mgzw@mwanda>
        <20180604193250.GB32753@L80496>
        <20180605073631.cvp2iuef4yb636jz@mwanda>
        <20180605083325.GA6965@L80496>
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 5 Jun 2018 10:33:25 +0200
Thibaut Robert <thibaut.robert@gmail.com> wrote:

> Le mardi 05 juin 2018 à 10:36:31 (+0300), Dan Carpenter a écrit :
> > On Mon, Jun 04, 2018 at 09:32:50PM +0200, Thibaut Robert wrote:  
> > > Le mercredi 30 mai 2018 à 14:17:25 (+0300), Dan Carpenter a
> > > écrit :  
> > > > On Tue, May 29, 2018 at 09:11:43PM +0200, Thibaut Robert
> > > > wrote:  
> > > > > diff --git
> > > > > a/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
> > > > > b/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c index
> > > > > e248702ee519..745bf5ca2622 100644 ---
> > > > > a/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c +++
> > > > > b/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c @@
> > > > > -1431,7 +1431,7 @@ void wilc_wfi_p2p_rx(struct net_device
> > > > > *dev, u8 *buff, u32 size) freq =
> > > > > ieee80211_channel_to_frequency(curr_channel,
> > > > > NL80211_BAND_2GHZ); 
> > > > > -	if (!ieee80211_is_action(buff[FRAME_TYPE_ID])) {
> > > > > +	if
> > > > > (!ieee80211_is_action(cpu_to_le16(buff[FRAME_TYPE_ID]))) {  
> > > > 
> > > > "buff" comes from the network, it's going to be little endian,
> > > > not cpu endian.  The rest of the function treats it as CPU
> > > > endian but I'm pretty sure it's wrong...  
> > > buff comes from the network but we are looking at single byte
> > > here. ieee80211_is_action expects an le16, so we I added this to
> > > extend an u8 to an le16. Is this incorrect ?
> > > 
> > > Or maybe we the buff has the second byte ? but that I can't
> > > tell.   
> > 
> > You raise a good point that I hadn't seen. The original code is
> > clearly buggy.  But your fix isn't correct either...  The other
> > thing to consider is that cpu_to_le16() is basically a cast to u16
> > on x86 so it's a no-op here.  
> The sparse warning is clearly spotting a real issue. I tried to at
> least have big endian handle correctly the 0-255 case. I am willing
> to drop the change (since I agree it's not very satisfying and will
> mask an issue), but may I ask you to explain how it is wrong ? How
> would you correctly expand an u8 to __le16 ? I think in big endian we
> need to swap the bytes.
> 

Yes, when sending the data to ieee80211_is_action() it should pass
16bit value instead of 8bit value. It should be corrected.

But the buff received from the wifi module is already in little endian
format. As the data is already in LE endian format so in my opinion
the conversion is not required while calling ieee80211_is_action().
  
> > 
> > Really the right thing is to not treat buff as an array of u8 but a
> > struct.  The code assumes that frame_type is 0-255 but probably it's
> > supposed to go up to U16_MAX.
> > 
> > struct whatever {
> > 	__le16 frame_type;
> > 	...
> > 
> > There probably is already a struct like that, but I don't know what
> > it is.  I don't know this code at all, I'm just guessing.
> >   
> I was thinking the same. I don't know whether this buf contains a
> standard struct or something hw-specific. I'll try to dig further and
> submit a separate patch if I can. Maybe Aditya can give more
> information ?
> 

The buffer structure contains both some custom information along
with standard info. As the frame_control is the first 2 byte in the in
buff so casting it can also help to extract frame_control.

Please refer the code in mgmt_tx() which use like below

const struct ieee80211_mgmt *mgmt;
....
mgmt = (const struct ieee80211_mgmt *)buf;

ieee80211_is_action(mgmt->frame_control)


I think another approach can be by using proper type cast with first 2
bytes of buffer(to extract 16bit value) and pass it to
ieee80211_is_action().


Regards,
Ajay

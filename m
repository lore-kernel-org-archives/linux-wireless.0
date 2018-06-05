Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from userp2130.oracle.com ([156.151.31.86]:44516 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751449AbeFEHgr (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 5 Jun 2018 03:36:47 -0400
Date: Tue, 5 Jun 2018 10:36:31 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Thibaut Robert <thibaut.robert@gmail.com>
Cc: Aditya Shankar <aditya.shankar@microchip.com>,
        Ganesh Krishna <ganesh.krishna@microchip.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        devel@driverdev.osuosl.org, linux-wireless@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] staging: wilc1000: fix some endianness sparse
 warnings
Message-ID: <20180605073631.cvp2iuef4yb636jz@mwanda> (sfid-20180605_093703_357855_51F4D62D)
References: <20180529191143.13081-1-thibaut.robert@gmail.com>
 <20180530111725.gmigyddsp2i6mgzw@mwanda>
 <20180604193250.GB32753@L80496>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
In-Reply-To: <20180604193250.GB32753@L80496>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Jun 04, 2018 at 09:32:50PM +0200, Thibaut Robert wrote:
> Le mercredi 30 mai 2018 à 14:17:25 (+0300), Dan Carpenter a écrit :
> > On Tue, May 29, 2018 at 09:11:43PM +0200, Thibaut Robert wrote:
> > > diff --git a/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c b/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
> > > index e248702ee519..745bf5ca2622 100644
> > > --- a/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
> > > +++ b/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
> > > @@ -1431,7 +1431,7 @@ void wilc_wfi_p2p_rx(struct net_device *dev, u8 *buff, u32 size)
> > >  
> > >  	freq = ieee80211_channel_to_frequency(curr_channel, NL80211_BAND_2GHZ);
> > >  
> > > -	if (!ieee80211_is_action(buff[FRAME_TYPE_ID])) {
> > > +	if (!ieee80211_is_action(cpu_to_le16(buff[FRAME_TYPE_ID]))) {
> > 
> > "buff" comes from the network, it's going to be little endian, not cpu
> > endian.  The rest of the function treats it as CPU endian but I'm pretty
> > sure it's wrong...
> buff comes from the network but we are looking at single byte here.
> ieee80211_is_action expects an le16, so we I added this to extend an u8
> to an le16. Is this incorrect ?
> 
> Or maybe we the buff has the second byte ? but that I can't tell. 

You raise a good point that I hadn't seen. The original code is clearly
buggy.  But your fix isn't correct either...  The other thing to
consider is that cpu_to_le16() is basically a cast to u16 on x86 so it's
a no-op here.

Really the right thing is to not treat buff as an array of u8 but a
struct.  The code assumes that frame_type is 0-255 but probably it's
supposed to go up to U16_MAX.

struct whatever {
	__le16 frame_type;
	...

There probably is already a struct like that, but I don't know what it
is.  I don't know this code at all, I'm just guessing.

regards,
dan carpenter

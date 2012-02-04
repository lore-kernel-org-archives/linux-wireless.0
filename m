Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nm20.bullet.mail.ukl.yahoo.com ([217.146.183.194]:24622 "HELO
	nm20.bullet.mail.ukl.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751008Ab2BDGIn (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 4 Feb 2012 01:08:43 -0500
From: Marek Lindner <lindner_marek@yahoo.de>
To: Seth Forshee <seth.forshee@canonical.com>
Subject: Re: CTS timeout issue with AR9285
Date: Sat, 4 Feb 2012 14:08:35 +0800
Cc: Felix Fietkau <nbd@openwrt.org>, linux-wireless@vger.kernel.org,
	"Luis R. Rodriguez" <mcgrof@qca.qualcomm.com>,
	Jouni Malinen <jouni@qca.qualcomm.com>,
	Vasanthakumar Thiagarajan <vthiagar@qca.qualcomm.com>,
	Senthil Balasubramanian <senthilb@qca.qualcomm.com>
References: <20120202042521.GA20635@ubuntu-macmini> <4F2A830A.8000905@openwrt.org> <20120202143843.GB24483@ubuntu-macmini>
In-Reply-To: <20120202143843.GB24483@ubuntu-macmini>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Message-Id: <201202041408.35588.lindner_marek@yahoo.de> (sfid-20120204_070911_781131_04E4EB1B)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thursday, February 02, 2012 22:38:43 Seth Forshee wrote:
> On Thu, Feb 02, 2012 at 01:35:22PM +0100, Felix Fietkau wrote:
> > On 2012-02-02 5:25 AM, Seth Forshee wrote:
> > > I recently updated a machine with AR9285 wireless from kernel version
> > > 3.0 to 3.2 and saw that wireless had become slow and unreliable. It
> > > seems that the problem is extremely frequent CTS timeouts, which began
> > > happening with commit adb5066 (ath9k_hw: do not apply the 2.4 ghz ack
> > > timeout workaround to cts). Restoring the CTS timeout to the value
> > > prior to this commit on top of 3.2 gets performance back to what it
> > > was with 3.0.
> > > 
> > > I don't have any other ath9k cards lying around, but various other
> > > cards are working fine with this router. Any ideas what's wrong here?
> > 
> > Please try this patch:
> > 
> > --- a/drivers/net/wireless/ath/ath9k/hw.c
> > +++ b/drivers/net/wireless/ath/ath9k/hw.c
> > @@ -1061,13 +1061,16 @@ void ath9k_hw_init_global_settings(struc
> > 
> >  	/*
> >  	
> >  	 * Workaround for early ACK timeouts, add an offset to match the
> > 
> > -	 * initval's 64us ack timeout value.
> > +	 * initval's 64us ack timeout value. Use 48us for the CTS timeout.
> > 
> >  	 * This was initially only meant to work around an issue with delayed
> >  	 * BA frames in some implementations, but it has been found to fix 
ACK
> >  	 * timeout issues in other cases as well.
> >  	 */
> > 
> > -	if (conf->channel && conf->channel->band == IEEE80211_BAND_2GHZ)
> > +	if (conf->channel && conf->channel->band == IEEE80211_BAND_2GHZ) {
> > 
> >  		acktimeout += 64 - sifstime - ah->slottime;
> > 
> > +		ctstimeout += 48 - sifstime - ah->slottime;
> > +	}
> > +
> > 
> >  	ath9k_hw_set_sifs_time(ah, sifstime);
> >  	ath9k_hw_setslottime(ah, slottime);
> 
> The wireless seems to be working fine with this patch.

I second this - my rts/cts problems went away as well after applying this 
patch.

Regards,
Marek

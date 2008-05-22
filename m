Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:33523 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752076AbYEVTSq (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 22 May 2008 15:18:46 -0400
Subject: Re: iwl4965 - wpa_supplicant can't see 5Ghz frequencies -
	2.6.26-rc1 kernel
From: Dan Williams <dcbw@redhat.com>
To: Pavel Roskin <proski@gnu.org>
Cc: Johannes Berg <johannes@sipsolutions.net>,
	Tomas Winkler <tomasw@gmail.com>,
	Vincent C Jones <v.jones@networkingunlimited.com>,
	linux-wireless@vger.kernel.org,
	Emmanuel Grumbach <egrumbach@gmail.com>
In-Reply-To: <1211482203.18709.9.camel@dv>
References: <1210352234.3763.23.camel@X61.NetworkingUnlimited.com>
	 <1ba2fa240805091712gccaec9cibdab621e8d1c9ba7@mail.gmail.com>
	 <1210430367.3778.9.camel@X61.NetworkingUnlimited.com>
	 <1210434402.3787.7.camel@X61.NetworkingUnlimited.com>
	 <1ba2fa240805101156q4dc52c2bt47d2f6e51b611eea@mail.gmail.com>
	 <1210456110.3787.26.camel@X61.NetworkingUnlimited.com>
	 <1ba2fa240805101506p78c3eeb6q6e980ac4200fd56f@mail.gmail.com>
	 <1210474179.3787.31.camel@X61.NetworkingUnlimited.com>
	 <1ba2fa240805120950mf983e97qac4cdfa2c84b6662@mail.gmail.com>
	 <1210617467.3792.4.camel@X61.DFGI.com>
	 <1ba2fa240805220953u746d3429q50faa1885104cadb@mail.gmail.com>
	 (sfid-20080522_185359_028598_D17C0097)  <1211478969.3698.56.camel@johannes.berg>
	 <1211481249.28022.15.camel@localhost.localdomain>
	 <1211482203.18709.9.camel@dv>
Content-Type: text/plain
Date: Thu, 22 May 2008 15:18:45 -0400
Message-Id: <1211483925.28022.23.camel@localhost.localdomain> (sfid-20080522_211848_918930_471F5732)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2008-05-22 at 14:50 -0400, Pavel Roskin wrote:
> On Thu, 2008-05-22 at 14:34 -0400, Dan Williams wrote:
> 
> > But what's the best fix to the supplicant?  It could just parse A-band
> > channels and where the numbers overlap, assume B/G band.  Or, it could
> > be patched to prefer FREQ+frequency over FREQ+channel if it received
> > both.  That's probably the best solution.
> 
> I checked the wpa_supplicant sources and I see that all it needs is the
> frequency.  All that needs to be done is not to allow channels
> (everything below, say, 10000) overwrite existing frequency data.
> That's the second approach.

works for me.  something like the following?  will repost to hostap list
if this looks ok.

diff --git a/src/drivers/driver_wext.c b/src/drivers/driver_wext.c
index 69aae16..60cdb79 100644
--- a/src/drivers/driver_wext.c
+++ b/src/drivers/driver_wext.c
@@ -1294,8 +1294,15 @@ static void wext_get_scan_freq(struct iw_event *iwe,
 		/*
 		 * Some drivers do not report frequency, but a channel.
 		 * Try to map this to frequency by assuming they are using
-		 * IEEE 802.11b/g.
+		 * IEEE 802.11b/g.  But don't overwrite a previously parsed
+		 * frequency if the driver sends both frequency and channel,
+		 * since the driver may be sending an A-band channel that we
+		 * don't handle here.
 		 */
+
+		if (res->res.freq)
+			return;
+
 		if (iwe->u.freq.m >= 1 && iwe->u.freq.m <= 13) {
 			res->res.freq = 2407 + 5 * iwe->u.freq.m;
 			return;

I guess the better solution would be to handle A-band channels too.  Is
there a canonical mapping of channel # to frequency somewhere for the
A-band stuff?  I put together the following table a while ago from
googling around which is probably the wrong way to do it, but... my
sources were mainly wikipedia channel maps for 802.11a and some cisco
docs from somewhere.

Dan

static struct cf_pair a_table[] = {
	/* A band */
	{  7, 5035 },
	{  8, 5040 },
	{  9, 5045 },
	{ 11, 5055 },
	{ 12, 5060 },
	{ 16, 5080 },
	{ 34, 5170 },
	{ 36, 5180 },
	{ 38, 5190 },
	{ 40, 5200 },
	{ 42, 5210 },
	{ 44, 5220 },
	{ 46, 5230 },
	{ 48, 5240 },
	{ 50, 5250 },
	{ 52, 5260 },
	{ 56, 5280 },
	{ 58, 5290 },
	{ 60, 5300 },
	{ 64, 5320 },
	{ 100, 5500 },
	{ 104, 5520 },
	{ 108, 5540 },
	{ 112, 5560 },
	{ 116, 5580 },
	{ 120, 5600 },
	{ 124, 5620 },
	{ 128, 5640 },
	{ 132, 5660 },
	{ 136, 5680 },
	{ 140, 5700 },
	{ 149, 5745 },
	{ 152, 5760 },
	{ 153, 5765 },
	{ 157, 5785 },
	{ 160, 5800 },
	{ 161, 5805 },
	{ 165, 5825 },
	{ 183, 4915 },
	{ 184, 4920 },
	{ 185, 4925 },
	{ 187, 4935 },
	{ 188, 4945 },
	{ 192, 4960 },
	{ 196, 4980 },
	{ 0, -1 }
};



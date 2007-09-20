Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from madara.hpl.hp.com ([192.6.19.124]:54048 "EHLO madara.hpl.hp.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751181AbXITU5b (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 20 Sep 2007 16:57:31 -0400
Date: Thu, 20 Sep 2007 13:56:02 -0700
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Jouni Malinen <j@w1.fi>, Dan Williams <dcbw@redhat.com>,
	linux-wireless@vger.kernel.org
Subject: Re: wext 64-bit: network manager and wpa_supplicant
Message-ID: <20070920205602.GA15373@bougret.hpl.hp.com>
Reply-To: jt@hpl.hp.com
References: <1190292526.18521.52.camel@johannes.berg> <20070920165545.GA29452@bougret.hpl.hp.com> <1190307669.18521.94.camel@johannes.berg>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="y0ulUmNC+osPPQO6"
In-Reply-To: <1190307669.18521.94.camel@johannes.berg>
From: Jean Tourrilhes <jt@hpl.hp.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--y0ulUmNC+osPPQO6
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Sep 20, 2007 at 07:01:09PM +0200, Johannes Berg wrote:
> 
> > 	Then, I modified NetworkManaged to use libiw for scan
> > parsing. The idea was to simplify NetworkManager and fix the 32-64 bit
> > bug, plus a few other potential gotchas. The first version of
> > NetworkManager to include that fix is 0.6.5. But, I've just realised
> > that I did not convert event parsing, which could be an issue, I'll
> > try to work on that.
> > 	Note that the other big issue is that, if wpa_supplicant is
> > present, NetworkManager will request the scan from it, and won't use
> > its internal code, so all those fixes are useless. Maybe there should
> > be a control to force NetworkManager to use its own scan code when
> > needed.
> 
> Does NM always use wpa_supplicant even in 0.6.5? I thought only later
> versions deferred everything to it.

	That was my assumption as well, and the reason I spent time
doing my patch. However, after your bug report, and before replying to
you, I went back looking at the code, to verify.
	Well, as it happens, 0.6.5 uses wpa_supplicant for the scan if
it's available (more below).

> > 	As far as I know, Debian testing (Lenny) has those
> > packages. Of course, I would not mind if you could test all this,
> > verify that the packages are the right version and that iwlist works
> > properly. If iwlist does not work, the rest will never works.
> 
> iwlist works fine on my quad G5 box, but NM doesn't. I suppose then it
> does use wpa_supplicant.

	Ok, we are making slow progress, but at least we are making
progress. We are highly dependant on good bug reports.

> > 	With respect to wpa_supplicant. Well, I sent multiple e-mail
> > to Jouni to inform him about this. My personaly inclination would be
> > to rip the custom parsing code of wpa_supplicant and use libiw
> > instead, but Jouni will never accept that. Maybe you should use
> > xsupplicant instead.
> 
> Can't really use xsupplicant, since NM relies on it and we want the
> kernel to rely more on wpa_supplicant (or another userspace MLME
> implementation). Is it really hard to fix the parsing code in
> wpa_supplicant? I'm not familiar with the workaround at all.

	Ask Jouni ?
	For someone familiar with it, it's actually trivial, you just
have to follow the patch for Wireless Tools. But for somebody
unfamiliar, there is a huge learning curve.
	That's classical : all the eyes are on the kernel, and nobody
care about userspace. We really should have more people familiar with
the guts of wpa_supplicant.

> > 	Ok, I see what's happening. That would just prevent you to set
> > authentication information, but that is not the root caause of your
> > problems. I'll puch a fix ASAP to John.
> 
> Not sure, this seems to make wpa_supplicant unhappy enough to not even
> start doing anything. But then I configured it for WPA.

	Patch sent. Can't do harm anyway.

> johannes

	I'm currently stuck because I don't have a box handy to try
NetworkManager on, most of my boxes are without all the Gnome
overhead. I'll try to fix that, but it may take a few days.
	Meanwhile, I made a few patch just for you for NetworkManager
0.6.5. I could not even try to compile it (./configure dependancy), so
beware.

	The first patch fix the event parsing code to use the libiw
helpers. As you can see, this dramatically reduce the code
complexity. However, as this code does not use the payload of events,
it should not have been affected by the 32-64 bit issue.

	The second patch force NetworkManager to always use its own
scanning code. This is a quick hack, I don't know what will be the
interaction with wpa_supplicant and I don't know when this part of
NetworkManager was last tested.
	In theory, with that change, you should start to see a list of
networks in NetworkManager.

	Have fun...

	Jean

--y0ulUmNC+osPPQO6
Content-Type: text/x-diff; charset=us-ascii
Content-Disposition: attachment; filename="nm065-iwlib-event.diff"

diff -u -p src/nm-device-802-11-wireless.j1.c src/nm-device-802-11-wireless.c
--- src/nm-device-802-11-wireless.j1.c	2007-09-20 13:17:46.000000000 -0700
+++ src/nm-device-802-11-wireless.c	2007-09-20 13:26:38.000000000 -0700
@@ -476,7 +476,8 @@ wireless_event_helper (gpointer user_dat
 	NMDevice80211Wireless *	self;
 	WirelessEventCBData *	cb_data;
 	struct iw_event iwe_buf, *iwe = &iwe_buf;
-	char *pos, *end, *custom;
+	struct stream_descr	stream;
+	int			ret;
 
 	cb_data = (WirelessEventCBData *) user_data;
 	g_return_val_if_fail (cb_data != NULL, FALSE);
@@ -487,40 +488,21 @@ wireless_event_helper (gpointer user_dat
 	g_return_val_if_fail (cb_data->data != NULL, FALSE);
 	g_return_val_if_fail (cb_data->len >= 0, FALSE);
 
-	pos = cb_data->data;
-	end = cb_data->data + cb_data->len;
+	/* Init stream descriptor */
+	iw_init_event_stream(&stream, (char *) res_buf, res_buf_len);
 
-	while (pos + IW_EV_LCP_LEN <= end)
+	while (1)
 	{
-		/* Event data may be unaligned, so make a local, aligned copy
-		 * before processing. */
-		memcpy (&iwe_buf, pos, IW_EV_LCP_LEN);
-		if (iwe->len <= IW_EV_LCP_LEN)
+		/* Extract an event */
+		ret = iw_extract_event_stream(&stream, &iwe_buf, self->priv->we_version);
+		if(ret <= 0)
 			break;
 
-		custom = pos + IW_EV_POINT_LEN;
-		if (self->priv->we_version > 18 &&
-		    (iwe->cmd == IWEVMICHAELMICFAILURE ||
-		     iwe->cmd == IWEVCUSTOM ||
-		     iwe->cmd == IWEVASSOCREQIE ||
-		     iwe->cmd == IWEVASSOCRESPIE ||
-		     iwe->cmd == IWEVPMKIDCAND))
-		{
-			/* WE-19 removed the pointer from struct iw_point */
-			char *dpos = (char *) &iwe_buf.u.data.length;
-			int dlen = dpos - (char *) &iwe_buf;
-			memcpy (dpos, pos + IW_EV_LCP_LEN,
-			       sizeof (struct iw_event) - dlen);
-		}
-		else
-		{
-			memcpy (&iwe_buf, pos, sizeof (struct iw_event));
-			custom += IW_EV_POINT_OFF;
-		}
-
+		iwe = &iwe_buf;		/* Prevent gcc unstrict-aliasing */
 		switch (iwe->cmd)
 		{
 			case SIOCGIWAP:
+				/* Association status */
 				if (   memcmp(iwe->u.ap_addr.sa_data,
 					   "\x00\x00\x00\x00\x00\x00", ETH_ALEN) == 0
 				    || memcmp(iwe->u.ap_addr.sa_data,
@@ -542,7 +524,6 @@ wireless_event_helper (gpointer user_dat
 					schedule_scan_results_timeout (self, 5);
 				break;
 		}
-		pos += iwe->len;
 	}
 
 	return FALSE;
@@ -3449,7 +3430,6 @@ process_scan_results (NMDevice80211Wirel
 	int maxrate;
 	struct iw_event iwe_buf, *iwe = &iwe_buf;
 	struct stream_descr	stream;
-	struct wireless_scan *	wscan = NULL;
 	int			ret;
 
 	g_return_val_if_fail (dev != NULL, FALSE);

--y0ulUmNC+osPPQO6
Content-Type: text/x-diff; charset=us-ascii
Content-Disposition: attachment; filename="nm065-scan-nosupplicant.diff"

diff -u -p src/nm-device-802-11-wireless.j2.c src/nm-device-802-11-wireless.c
--- src/nm-device-802-11-wireless.j2.c	2007-09-20 13:33:47.000000000 -0700
+++ src/nm-device-802-11-wireless.c	2007-09-20 13:35:35.000000000 -0700
@@ -2093,7 +2093,8 @@ nm_device_802_11_wireless_scan (gpointer
 	 * the scan request rather than doing it ourselves.
 	 */
 	iface = nm_device_get_iface (NM_DEVICE (self));
-	if (self->priv->supplicant.ctrl)
+	//if (self->priv->supplicant.ctrl)
+	if (0)
 	{
 		if (nm_utils_supplicant_request_with_check (self->priv->supplicant.ctrl,
 				"OK", __func__, NULL, "SCAN"))

--y0ulUmNC+osPPQO6--
-: 
To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
the body of a message to majordomo@vger.kernel.org: 
More majordomo info at  http: //vger.kernel.org/majordomo-info.html

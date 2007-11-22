Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from py-out-1112.google.com ([64.233.166.177]:30809 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751714AbXKVUcZ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 22 Nov 2007 15:32:25 -0500
Received: by py-out-1112.google.com with SMTP id u77so8094032pyb
        for <linux-wireless@vger.kernel.org>; Thu, 22 Nov 2007 12:32:24 -0800 (PST)
Message-ID: <8e6f94720711221232p16b90daaya5fe3550729b49c8@mail.gmail.com> (sfid-20071122_203229_611190_A62E3537)
Date: Thu, 22 Nov 2007 15:32:20 -0500
From: "Will Dyson" <will.dyson@gmail.com>
To: "Holger Schurig" <hs4233@mail.mn-solutions.de>
Subject: Re: mac80211 regression: doesn't associate automatically
Cc: linux-wireless@vger.kernel.org,
	"Johannes Berg" <johannes@sipsolutions.net>
In-Reply-To: <200711221719.40412.hs4233@mail.mn-solutions.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
References: <200711220912.10452.hs4233@mail.mn-solutions.de>
	 <200711221605.55506.hs4233@mail.mn-solutions.de>
	 <1195746110.4149.23.camel@johannes.berg>
	 <200711221719.40412.hs4233@mail.mn-solutions.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Nov 22, 2007 11:19 AM, Holger Schurig <hs4233@mail.mn-solutions.de> wrote:

> If I accept both sentences as valid, I must conclude that
> mac80211 is faulty. It happens that mac80211 triggers an
> association to an access-point also by the "iwconfig XXX essid
> YYYY" command. This is not defined. Hey, wait a minute. mac80211
> is not allowed to do ANYTHING that is undefined, because tools
> can only rely on defined things. So mac80211 is faulty. Crap,
> ditch it.

Hi Holger,

I understand you are frustrated, but your tone is not helping to make
this a productive discussion. Please keep in mind that fixing this
stuff is not anybody's day job right now.

Also, are you sure you understand completely what is going on? As far
as I can see, the Debian wireless-tools ifup script (package version
29-1) *is* setting the key before it sets the essid. In fact, setting
the ssid and key both happen in a pre-up script, which is run before
the interface is even brought up.

So it should be working for you, based on that. What version of the
package do you have?

Johannes,

It doesn't look like it should be so hard to make setting the key
trigger association. And I don't think that if we allow setting the
key to trigger association, that it obligates us to reassociate on
every other event that could effect it. As you said, wext spec is
silent on this matter.

It does seem silly to set the key after the essid, but unless it
really hurts elsewhere, we can be liberal in what we accept.

My (probably wrong, compile-tested only, for review only) patch to
implement this:

I know it is word-wrapped by Gmail. Sorry, I'm late to a family event as-is.

diff --git a/net/mac80211/ieee80211_ioctl.c b/net/mac80211/ieee80211_ioctl.c
index 503b64a..6ce79e4 100644
--- a/net/mac80211/ieee80211_ioctl.c
+++ b/net/mac80211/ieee80211_ioctl.c
@@ -839,6 +839,7 @@ static int ieee80211_ioctl_siwencode(struct net_device *dev,
 	int idx, i, alg = ALG_WEP;
 	u8 bcaddr[ETH_ALEN] = { 0xff, 0xff, 0xff, 0xff, 0xff, 0xff };
 	int remove = 0;
+	int ret;

 	sdata = IEEE80211_DEV_TO_SUB_IF(dev);

@@ -864,11 +865,16 @@ static int ieee80211_ioctl_siwencode(struct
net_device *dev,
 		return 0;
 	}

-	return ieee80211_set_encryption(
+	ret = ieee80211_set_encryption(
 		dev, bcaddr,
 		idx, alg, remove,
 		!sdata->default_key,
 		keybuf, erq->length);
+	if (ret)
+		return ret;
+
+	ieee80211_sta_req_auth(dev, &sdata->u.sta);
+	return 0;
 }


@@ -1015,6 +1021,7 @@ static int ieee80211_ioctl_siwencodeext(struct
net_device *dev,
 	struct ieee80211_sub_if_data *sdata = IEEE80211_DEV_TO_SUB_IF(dev);
 	struct iw_encode_ext *ext = (struct iw_encode_ext *) extra;
 	int uninitialized_var(alg), idx, i, remove = 0;
+	int ret;

 	switch (ext->alg) {
 	case IW_ENCODE_ALG_NONE:
@@ -1052,11 +1059,16 @@ static int ieee80211_ioctl_siwencodeext(struct
net_device *dev,
 	} else
 		idx--;

-	return ieee80211_set_encryption(dev, ext->addr.sa_data, idx, alg,
+	ret = ieee80211_set_encryption(dev, ext->addr.sa_data, idx, alg,
 					remove,
 					ext->ext_flags &
 					IW_ENCODE_EXT_SET_TX_KEY,
 					ext->key, ext->key_len);
+	if (ret)
+		return ret;
+
+	ieee80211_sta_req_auth(dev, &sdata->u.sta);
+	return 0;
 }

-- 
Will Dyson

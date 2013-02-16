Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from perches-mx.perches.com ([206.117.179.246]:55011 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754174Ab3BPUEN (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 16 Feb 2013 15:04:13 -0500
Message-ID: <1361045050.1948.4.camel@joe-AO722> (sfid-20130216_210424_709262_0609353B)
Subject: Re: [PATCH 3/3] mac80211: don't spam mesh probe response messages
From: Joe Perches <joe@perches.com>
To: Thomas Pedersen <thomas@cozybit.com>
Cc: johannes@sipsolutions.net, linux-wireless@vger.kernel.org,
	devel@lists.open80211s.org
Date: Sat, 16 Feb 2013 12:04:10 -0800
In-Reply-To: <1361040066-5771-3-git-send-email-thomas@cozybit.com>
References: <1361040066-5771-1-git-send-email-thomas@cozybit.com>
	 <1361040066-5771-3-git-send-email-thomas@cozybit.com>
Content-Type: text/plain; charset="ISO-8859-1"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sat, 2013-02-16 at 10:41 -0800, Thomas Pedersen wrote:
> If mesh plink debugging is enabled, this gets annoying in
> a crowded environment, fast.
> 
> Signed-off-by: Thomas Pedersen <thomas@cozybit.com>
> ---
>  net/mac80211/mesh.c |    1 -
>  1 file changed, 1 deletion(-)
> 
> diff --git a/net/mac80211/mesh.c b/net/mac80211/mesh.c
> index b022332..29ce2aa 100644
> --- a/net/mac80211/mesh.c
> +++ b/net/mac80211/mesh.c
> @@ -925,7 +925,6 @@ ieee80211_mesh_rx_probe_req(struct ieee80211_sub_if_data *sdata,
>  	hdr->frame_control = cpu_to_le16(IEEE80211_FTYPE_MGMT |
>  					 IEEE80211_STYPE_PROBE_RESP);
>  	memcpy(hdr->da, mgmt->sa, ETH_ALEN);
> -	mpl_dbg(sdata, "sending probe resp. to %pM\n", hdr->da);

I think the problem isn't here so much as
_sdata_dbg which doesn't allow per-site
control via dynamic_debug.

How about adding that instead or perhaps
using some ratelimit control?

Something like:

 net/mac80211/debug.h | 6 +++++-
 net/mac80211/trace.c | 2 --
 2 files changed, 5 insertions(+), 3 deletions(-)

diff --git a/net/mac80211/debug.h b/net/mac80211/debug.h
index 8f383a5..da102d6 100644
--- a/net/mac80211/debug.h
+++ b/net/mac80211/debug.h
@@ -72,7 +72,11 @@ void __wiphy_dbg(struct wiphy *wiphy, bool print, const char *fmt, ...)
 #define _sdata_info(sdata, fmt, ...)					\
 	__sdata_info("%s: " fmt, (sdata)->name, ##__VA_ARGS__)
 #define _sdata_dbg(print, sdata, fmt, ...)				\
-	__sdata_dbg(print, "%s: " fmt, (sdata)->name, ##__VA_ARGS__)
+do {									\
+	if (print)							\
+		pr_debug(fmt, ##__VA_ARGS__);				\
+	__sdata_dbg(print, "%s: " fmt, (sdata)->name, ##__VA_ARGS__);	\
+} while (0)
 #define _sdata_err(sdata, fmt, ...)					\
 	__sdata_err("%s: " fmt, (sdata)->name, ##__VA_ARGS__)
 #define _wiphy_dbg(print, wiphy, fmt, ...)				\
diff --git a/net/mac80211/trace.c b/net/mac80211/trace.c
index 386e45d..03a70fc 100644
--- a/net/mac80211/trace.c
+++ b/net/mac80211/trace.c
@@ -35,8 +35,6 @@ void __sdata_dbg(bool print, const char *fmt, ...)
 	va_start(args, fmt);
 	vaf.va = &args;
 
-	if (print)
-		pr_debug("%pV", &vaf);
 	trace_mac80211_dbg(&vaf);
 	va_end(args);
 }



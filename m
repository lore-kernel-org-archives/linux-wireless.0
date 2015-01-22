Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ie0-f173.google.com ([209.85.223.173]:38321 "EHLO
	mail-ie0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751906AbbAVPZ5 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 22 Jan 2015 10:25:57 -0500
Received: by mail-ie0-f173.google.com with SMTP id tr6so1897531ieb.4
        for <linux-wireless@vger.kernel.org>; Thu, 22 Jan 2015 07:25:56 -0800 (PST)
MIME-Version: 1.0
Date: Thu, 22 Jan 2015 16:25:56 +0100
Message-ID: <CAGXE3d9YGt=z1oKs8h+di9u6+uOuyNkiM6z0q+viBp5DnYZdNg@mail.gmail.com> (sfid-20150122_162600_465418_A6BE20A9)
Subject: DFS issue on ath10k
From: Helmut Schaa <helmut.schaa@googlemail.com>
To: linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

I've been seeing some issues with DFS on ath10k but this could
also affect ath9k.

In the end of the CAC period there seems to be a time window in
which ath10k won't detect any radar pulses (<1sec) before starting
operation on this channel. Reason is that the channel context for
CAC is getting removed and it takes some time for hostapd to
finish the hw setup so a new channel context gets set.

This is no suitable patch but provides some more insight into
this issue:

--- a/net/mac80211/chan.c
+++ b/net/mac80211/chan.c
@@ -494,9 +494,9 @@

  if (!local->use_chanctx) {
  struct cfg80211_chan_def *chandef = &local->_oper_chandef;
- chandef->width = NL80211_CHAN_WIDTH_20_NOHT;
+ /*chandef->width = NL80211_CHAN_WIDTH_20_NOHT;
  chandef->center_freq1 = chandef->chan->center_freq;
- chandef->center_freq2 = 0;
+ chandef->center_freq2 = 0;*/

  /* NOTE: Disabling radar is only valid here for
  * single channel context. To be sure, check it ...
@@ -504,7 +504,7 @@
  WARN_ON(local->hw.conf.radar_enabled &&
  !list_empty(&local->chanctx_list));

- local->hw.conf.radar_enabled = false;
+ local->hw.conf.radar_enabled =
cfg80211_chandef_dfs_required(local->hw.wiphy, chandef,
NL80211_IFTYPE_AP);

  ieee80211_hw_config(local, IEEE80211_CONF_CHANGE_CHANNEL);
  } else {


Not sure how to get this race free. hostapd might have to configure
the channel before the CAC period is finished so there is no
window without channel context.

Did anyone else notice this? Any ideas?

Thanks,
Helmut

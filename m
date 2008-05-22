Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wf-out-1314.google.com ([209.85.200.175]:18685 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752202AbYEVSwY (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 22 May 2008 14:52:24 -0400
Received: by wf-out-1314.google.com with SMTP id 27so164261wfd.4
        for <linux-wireless@vger.kernel.org>; Thu, 22 May 2008 11:52:21 -0700 (PDT)
Message-ID: <69e28c910805221152g199d83b9s225799d0e3e53bcd@mail.gmail.com> (sfid-20080522_205227_226919_97C3199A)
Date: Thu, 22 May 2008 20:52:21 +0200
From: "=?ISO-8859-1?Q?Stefanik_G=E1bor?=" <netrolller.3d@gmail.com>
To: "Johannes Berg" <johannes@sipsolutions.net>
Subject: Re: [PATCH] mac80211: do not alter injected seq numbers
Cc: JMF <tolas_feup@hotmail.com>,
	"=?ISO-8859-1?Q?Alejandro_Grijalba_Mart=EDnez?=" <sud@latinsud.com>,
	"Michael Buesch" <mb@bu3sch.de>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	"John Linville" <linville@tuxdriver.com>
In-Reply-To: <1211481278.3698.58.camel@johannes.berg>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
References: <47FAB829.9010304@latinsud.com> <200804081025.39645.mb@bu3sch.de>
	 <loom.20080522T171937-155@post.gmane.org>
	 <69e28c910805221115g6290e5e9nef4444efca07aea@mail.gmail.com>
	 <69e28c910805221121v1a34901co35ec41bff41bd1ec@mail.gmail.com>
	 <1211481278.3698.58.camel@johannes.berg>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, May 22, 2008 at 8:34 PM, Johannes Berg
<johannes@sipsolutions.net> wrote:
>> >> This does not work, since we use injection for other types of
>> >>  frames. For example management frames from hostapd. We don't want
>> >>  (and can't) make hostapd keep track of sequence numbers.
>> >> You'll have to contact radiotap people and add a flag for this.
>> >>  This would also solve the hardware counter problem then.
>
>> The flag is IEEE80211_TX_INJECTED. Here is a new patch, for the
>> current wireless-testing:
>
> Reorder the two blocks and you have your answer. NO.
>
> johannes
>

Hmm, shouldn't this version fix the hostap and other non-monitor-mode cases?

---

diff --git a/net/mac80211/tx.c b/net/mac80211/tx.c
index 1a3b50b..1fb4f92 100644
--- a/net/mac80211/tx.c
+++ b/net/mac80211/tx.c
@@ -292,6 +292,11 @@ ieee80211_tx_h_sequence(struct ieee80211_tx_data *tx)
 {
 	struct ieee80211_hdr *hdr = (struct ieee80211_hdr *)tx->skb->data;

+	/* Monitor mode injectors handle sequence numbers themselves */
+	if (unlikely(tx->flags & IEEE80211_TX_INJECTED) &&
+			     tx->sdata->vif.type == IEEE80211_IF_TYPE_MNTR)
+		return TX_CONTINUE;
+
 	if (ieee80211_get_hdrlen(le16_to_cpu(hdr->frame_control)) >= 24)
 		ieee80211_include_sequence(tx->sdata, hdr);

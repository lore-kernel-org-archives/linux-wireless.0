Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail30g.wh2.ocn.ne.jp ([220.111.41.239]:22305 "HELO
	mail30g.wh2.ocn.ne.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752638AbXJaGOy (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 31 Oct 2007 02:14:54 -0400
Received: from vs30c.wh2.ocn.ne.jp (222.146.55.196)
	by mail30g.wh2.ocn.ne.jp (RS ver 1.0.95vs) with SMTP id 4-0767761286
	for <linux-wireless@vger.kernel.org>; Wed, 31 Oct 2007 15:14:52 +0900 (JST)
From: bruno randolf <bruno@thinktube.com>
To: linux-wireless@vger.kernel.org
Subject: ilog2 overkill in ieee80211_get_hdrlen?
Date: Wed, 31 Oct 2007 15:14:48 +0900
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Message-Id: <200710311514.48896.bruno@thinktube.com> (sfid-20071031_061457_971015_857A735E)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

hello!

just a question...

in 'net/mac80211/util.c', in ieee80211_get_hdrlen (line 175), a function ilog2 
is used to determine the number of bits to shift for 
IEEE80211_STYPE_QOS_DATA. isn't that a bit of an overkill when we could just 
do >> 6? i mean IEEE80211_STYPE_QOS_DATA isn't going to change after all...

		/*
		 * The QoS Control field is two bytes and its presence is
		 * indicated by the IEEE80211_STYPE_QOS_DATA bit. Add 2 to
		 * hdrlen if that bit is set.
		 * This works by masking out the bit and shifting it to
		 * bit position 1 so the result has the value 0 or 2.
		 */
		hdrlen += (fc & IEEE80211_STYPE_QOS_DATA)
				>> (ilog2(IEEE80211_STYPE_QOS_DATA)-1);

i don't know if there is a reason for this, but it all seems overly 
complicated to me.

if (fc & IEEE80211_STYPE_QOS_DATA)
	hdrlen += 2;

would be a bit more readable.

bruno

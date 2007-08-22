Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nf-out-0910.google.com ([64.233.182.188]:56971 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1764756AbXHVTDZ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 22 Aug 2007 15:03:25 -0400
Received: by nf-out-0910.google.com with SMTP id g13so196449nfb
        for <linux-wireless@vger.kernel.org>; Wed, 22 Aug 2007 12:03:22 -0700 (PDT)
To: Johannes Berg <johannes@sipsolutions.net>
Subject: Re: [RFC 1/2] mac80211: allow drivers to indicate failed FCS/PLCP checksum
Date: Wed, 22 Aug 2007 21:11:03 +0200
Cc: linux-wireless@vger.kernel.org
References: <20070821161845.165557000@sipsolutions.net> <200708212307.59926.IvDoorn@gmail.com> <1187774561.4314.0.camel@johannes.berg>
In-Reply-To: <1187774561.4314.0.camel@johannes.berg>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Message-Id: <200708222111.03164.IvDoorn@gmail.com>
From: Ivo van Doorn <ivdoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wednesday 22 August 2007, Johannes Berg wrote:
> On Tue, 2007-08-21 at 23:07 +0200, Ivo van Doorn wrote:
> 
> > Do we need another flag to indicate ICV errors?
> > rt2x00 has the following fields to indicate problems during hardware decryption:
> > 	ICV error -> How to report this to mac80211?
> > 	MIC error -> The RX_FLAG_MMIC_ERROR flag can be set
> > 	invalid key -> Could best be done by just not setting RX_FLAG_DECRYPTED I assume.
> 
> I think you either just drop the packet or give it to mac80211 decrypted
> but with ICV still on so that mac80211 will verify the ICV (again) and
> do whatever is appropriate. But I think dropping it ought to be fine. Do
> we want this for monitoring maybe?

Not sure how interesting a frame with a ICV error will be,
on the other hand I am not even sure how a frame with a ICV error
looks like in rt2x00, discovering that will probably happen during
the hardware encryption implementation. ;)

Ivo

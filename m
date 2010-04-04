Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-fx0-f227.google.com ([209.85.220.227]:62913 "EHLO
	mail-fx0-f227.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751090Ab0DDTjl (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 4 Apr 2010 15:39:41 -0400
Received: by fxm27 with SMTP id 27so583943fxm.28
        for <linux-wireless@vger.kernel.org>; Sun, 04 Apr 2010 12:39:39 -0700 (PDT)
From: Max Filippov <jcmvbkbc@gmail.com>
To: Felix Fietkau <nbd@openwrt.org>
Subject: Re: [PATCH] mac80211: fix ieee80211_meshconf_ie::meshconf_cap type to be u16
Date: Sun, 4 Apr 2010 23:39:33 +0400
Cc: linux-wireless@vger.kernel.org
References: <1270375964-23668-1-git-send-email-jcmvbkbc@gmail.com> <4BB8D54F.7060906@openwrt.org>
In-Reply-To: <4BB8D54F.7060906@openwrt.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Message-Id: <201004042339.35467.jcmvbkbc@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

> On 2010-04-04 3:12 AM, Max Filippov wrote:
> > According to the current 802.11s draft mesh capability field
> > is 16 bits wide.
> > 
> > Signed-off-by: Max Filippov <jcmvbkbc@gmail.com>
> > ---
> >  include/linux/ieee80211.h |    2 +-
> >  1 files changed, 1 insertions(+), 1 deletions(-)
> > 
> > diff --git a/include/linux/ieee80211.h b/include/linux/ieee80211.h
> > index 1998495..910b4bc 100644
> > --- a/include/linux/ieee80211.h
> > +++ b/include/linux/ieee80211.h
> > @@ -604,7 +604,7 @@ struct ieee80211_meshconf_ie {
> >  	u8 meshconf_synch;
> >  	u8 meshconf_auth;
> >  	u8 meshconf_form;
> > -	u8 meshconf_cap;
> > +	u16 meshconf_cap;
> Shouldn't that be __le16? You probably also have to add le16_to_cpu in
> the place that accesses this field, otherwise this introduces an endian bug.

You're right, __le16. Will fix the way it's filled in mesh_mgmt_ies_add
and tested in mesh_peer_accepts_plinks and resend.

Thanks.
-- Max

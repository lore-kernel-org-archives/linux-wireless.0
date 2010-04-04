Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-fx0-f227.google.com ([209.85.220.227]:41258 "EHLO
	mail-fx0-f227.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751907Ab0DDT74 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 4 Apr 2010 15:59:56 -0400
Received: by fxm27 with SMTP id 27so591583fxm.28
        for <linux-wireless@vger.kernel.org>; Sun, 04 Apr 2010 12:59:54 -0700 (PDT)
From: Max Filippov <jcmvbkbc@gmail.com>
To: =?utf-8?b?0JvQtdC00L7QstGB0LrQuNGFINCd0LjQutC+0LvQsNC5?=
	 =?utf-8?b?INCS0LDQu9C10YDRjNC10LLQuNGH?= <nledovskih@mail.ru>
Subject: Re: [PATCH] mac80211: fix ieee80211_meshconf_ie::meshconf_cap type to be u16
Date: Sun, 4 Apr 2010 23:59:52 +0400
Cc: linux-wireless@vger.kernel.org
References: <1270375964-23668-1-git-send-email-jcmvbkbc@gmail.com> <20100404234549.9fba2292.nledovskih@mail.ru>
In-Reply-To: <20100404234549.9fba2292.nledovskih@mail.ru>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Message-Id: <201004042359.52494.jcmvbkbc@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

> On Sun,  4 Apr 2010 14:12:44 +0400
> Max Filippov <jcmvbkbc@gmail.com> wrote:
> 
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
> >  } __attribute__ ((packed));
> >  
> >  /**
> 
> May be it should be:
> 
> struct ieee80211_meshconf_ie {
>         u32 meshconf_psel;
>         u32 meshconf_pmetric;
>         u32 meshconf_congest;
>         u32 meshconf_synch;
>         u32 meshconf_auth;
>         u8 meshconf_form;
>         u16 meshconf_cap;
> } __attribute__ ((packed));
> 
> 

My reference is 802.11s-D4.01, it says (7.3.2.95.1):

Element id: 1 octet,
Length: 1 octet,
Active path selection protocol identifier: 1 octet,
Active path selection metric identifier: 1 octet,
Congestion control mode identifier: 1 octet,
Synchronization protocol identifier: 1 octet,
Authentication protocol identifier: 1 octet,
Mesh formation info: 1 octet,
Mesh capability: 2 octets.

The length field is set to 8.

Thanks.
-- Max

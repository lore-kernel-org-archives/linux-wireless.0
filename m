Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-vc0-f169.google.com ([209.85.220.169]:41677 "EHLO
	mail-vc0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751442Ab3HUIop (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 21 Aug 2013 04:44:45 -0400
Received: by mail-vc0-f169.google.com with SMTP id ib11so93119vcb.28
        for <linux-wireless@vger.kernel.org>; Wed, 21 Aug 2013 01:44:44 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1377032637.13829.42.camel@jlt4.sipsolutions.net>
References: <1377020479-16935-1-git-send-email-k.eugene.e@gmail.com>
	<1377020479-16935-12-git-send-email-k.eugene.e@gmail.com>
	<1377032637.13829.42.camel@jlt4.sipsolutions.net>
Date: Wed, 21 Aug 2013 10:44:44 +0200
Message-ID: <CAFSJ42YDoaso+szC-SG-E_o_83To7TSVyHF+w3FzXj=jv+ZQjA@mail.gmail.com> (sfid-20130821_104449_135998_24FF20AB)
Subject: Re: [PATCH 11/16] wcn36xx: Add txrx.c
From: Eugene Krasnikov <k.eugene.e@gmail.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	wcn36xx@lists.infradead.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

> On Tue, 2013-08-20 at 19:41 +0200, Eugene Krasnikov wrote:
>
>> +int wcn36xx_start_tx(struct wcn36xx *wcn,
>> +                  struct wcn36xx_sta *sta_priv,
>> +                  struct sk_buff *skb)
>
> err ... this can return errors that you never handle, probably gets you
> leaks that way?

Good catch. In some corner cases ieee80211_free_txskb is not called.

-- 
Best regards,
Eugene

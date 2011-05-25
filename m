Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from cpsmtpb-ews03.kpnxchange.com ([213.75.39.6]:4936 "EHLO
	cpsmtpb-ews03.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754984Ab1EYVBO (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 25 May 2011 17:01:14 -0400
Message-ID: <4DDD6E18.6090202@gmail.com> (sfid-20110525_230124_375044_568E1E92)
Date: Wed, 25 May 2011 23:01:12 +0200
From: Gertjan van Wingerde <gwingerde@gmail.com>
MIME-Version: 1.0
To: zhang lei <zhanglei901@gmail.com>
CC: linux-wireless@vger.kernel.org
Subject: Re: How to get the noise for ralink3070 using driver rt2x00
References: <BANLkTimiWtkO3Utb_9dJGHJMyk+-HCaLdQ@mail.gmail.com>
In-Reply-To: <BANLkTimiWtkO3Utb_9dJGHJMyk+-HCaLdQ@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 05/23/11 17:31, zhang lei wrote:
> I can't get the noise value while using driver rt2x00 for the ralink
> 3070, but I can get it if use the official driver, and I saw the
> article
> 
>  [PATCH] rt2x00: remove usage of deprecated noise value
> 
> said the noise field has deprecated.
> Is there a new field for noise to instead of the old noise filed? How
> can I get the noise value now?

The noise field was deprecated from mac80211 for the following reasons:
"The noise value as is won't be used, isn't filled by most drivers and doesn't really
make a whole lot of sense on a per packet basis -- proper cfg80211 survey support in
mac80211 will need to be different.

Mark the struct member as deprecated so it will be removed from drivers."

Since then no method has been available to get the noise value from the mac80211 based drivers.
If you feel there is a strong case for the noise value I suggest you start a discussion on the
linux-wireless mailing list.

---
Gertjan
 

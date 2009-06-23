Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from yw-out-2324.google.com ([74.125.46.30]:56808 "EHLO
	yw-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754491AbZFWQvz convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 23 Jun 2009 12:51:55 -0400
Received: by yw-out-2324.google.com with SMTP id 5so110874ywb.1
        for <linux-wireless@vger.kernel.org>; Tue, 23 Jun 2009 09:51:57 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <4A40F856.2010501@openwrt.org>
References: <1245751007.4184.17.camel@johannes.local>
	 <1245766038.21314.24.camel@johannes.local>
	 <4A40F856.2010501@openwrt.org>
Date: Tue, 23 Jun 2009 12:51:57 -0400
Message-ID: <b6c5339f0906230951v9766914vdc1d76f85eb62feb@mail.gmail.com>
Subject: Re: [PATCH v2] mac80211: fix todo lock
From: Bob Copeland <me@bobcopeland.com>
To: Gabor Juhos <juhosg@openwrt.org>
Cc: Johannes Berg <johannes@sipsolutions.net>,
	John Linville <linville@tuxdriver.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

2009/6/23 Gabor Juhos <juhosg@openwrt.org>:
> Johannes Berg írta:
>> The key todo lock can be taken from different locks
>> that require it to be _bh to avoid lock inversion
>> due to (soft)irqs.
>>
>> This should fix the two problems reported by Bob and
>> Gabor:
>> http://mid.gmane.org/20090619113049.GB18956@hash.localnet
>> http://mid.gmane.org/4A3FA376.8020307@openwrt.org

Hmm, I applied the patch, started hostapd, hit ctrl-c to
kill it, and got instant lockup.

I'll try to capture the panic/whatever next.

-- 
Bob Copeland %% www.bobcopeland.com

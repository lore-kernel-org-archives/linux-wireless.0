Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([88.198.39.176]:39174 "EHLO ds10.nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753132Ab0DPWJx (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 16 Apr 2010 18:09:53 -0400
Message-ID: <4BC8E027.1030807@openwrt.org>
Date: Sat, 17 Apr 2010 00:09:43 +0200
From: Felix Fietkau <nbd@openwrt.org>
MIME-Version: 1.0
To: Pavel Roskin <proski@gnu.org>
CC: "Luis R. Rodriguez" <lrodriguez@atheros.com>,
	linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	Vasanthakumar Thiagarajan <vasanth@atheros.com>
Subject: Re: [PATCH v3 42/97] ath9k: Make bf_desc of ath_buf opaque
References: <1271367582-992-1-git-send-email-lrodriguez@atheros.com>	 <1271367582-992-43-git-send-email-lrodriguez@atheros.com> <1271455259.16507.43.camel@mj>
In-Reply-To: <1271455259.16507.43.camel@mj>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 2010-04-17 12:00 AM, Pavel Roskin wrote:
> On Thu, 2010-04-15 at 17:38 -0400, Luis R. Rodriguez wrote:
>> From: Vasanthakumar Thiagarajan <vasanth@atheros.com>
>> 
>> Signed-off-by: Vasanthakumar Thiagarajan <vasanth@atheros.com>
> 
>> -	struct ath_desc *bf_desc;	/* virtual addr of desc */
>> +	void *bf_desc;			/* virtual addr of desc */
> 
> Why?
> 
> The obvious downside is that bf_desc becomes compatible with pointers of
> any type.
Because on AR9300 where it's used, it points to a struct ar9003_txc instead.

> The only upside I can think of is that bf_desc won't be dereferenced by
> accident.  The same could be done by using a scalar type or
> __attribute__((noderef)).
I don't think a scalar type makes any sense for this, because it is a
pointer, and it does get passed to functions that dereference it.
In cases where struct ar9003_txc is used, it'd have to pass through
either an explicit cast or an implicit one going through void* anyway,
so we might as well make it clear that while bf_desc is a valid pointer,
it does not always point to struct ath_desc

- Felix

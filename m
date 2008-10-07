Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fk-out-0910.google.com ([209.85.128.190]:45027 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752572AbYJGUGn (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 7 Oct 2008 16:06:43 -0400
Received: by fk-out-0910.google.com with SMTP id 18so2942918fkq.5
        for <linux-wireless@vger.kernel.org>; Tue, 07 Oct 2008 13:06:40 -0700 (PDT)
Message-ID: <1ba2fa240810071306sb282e06h9d29ea2c36f5c3d5@mail.gmail.com> (sfid-20081007_220651_271855_A94C7A77)
Date: Tue, 7 Oct 2008 22:06:40 +0200
From: "Tomas Winkler" <tomasw@gmail.com>
To: "Johannes Berg" <johannes@sipsolutions.net>
Subject: Re: [PATCH] iwlwifi: get rid of IWL_{GET,SET}_BITS crap
Cc: "John W. Linville" <linville@tuxdriver.com>,
	"Christoph Hellwig" <hch@infradead.org>,
	"Holger Schurig" <hs4233@mail.mn-solutions.de>,
	linux-wireless@vger.kernel.org
In-Reply-To: <1223408342.3618.7.camel@johannes.berg>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
References: <1223311803.15196.36.camel@johannes.berg>
	 <1ba2fa240810061135t24f2dfbv2a5eb0cd5d9e8cd7@mail.gmail.com>
	 <200810070821.56462.hs4233@mail.mn-solutions.de>
	 <20081007071529.GA5010@infradead.org>
	 <20081007131615.GR3448@tuxdriver.com>
	 <1ba2fa240810070703j471faa30mce3678febf3c20e8@mail.gmail.com>
	 <1223398724.7328.45.camel@johannes.berg>
	 <1ba2fa240810071228m52a60861r5558529426b9b487@mail.gmail.com>
	 <1223408085.3618.2.camel@johannes.berg>
	 <1223408342.3618.7.camel@johannes.berg>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Oct 7, 2008 at 9:39 PM, Johannes Berg <johannes@sipsolutions.net> wrote:
> On Tue, 2008-10-07 at 21:34 +0200, Johannes Berg wrote:
>
>> Then tell the HW engineers to fix the HW docs. It makes no sense at all
>> to say this is 10 pairs rather than 20 single ones if there's nothing
>> that uses a pair, the whole thing entirely uses single entries in the
>> numbering etc.
>
> If you need to visualise this, let me draw it:
>
> bytes (with nibbles): | . | . | . | . | . | . || . | . | . | . | . | . |
>                      | addr 1          |len1 || addr 2          |len2 |
> your forced layout:   |               |                |               |
> my layout:            |               |       ||               |       |
>
> Note how this actually matches the border between the border between the
> two descriptors, the || border.

Your layout put addr2 (which is 32 bit) sits on 16 bit boundary
Tomas

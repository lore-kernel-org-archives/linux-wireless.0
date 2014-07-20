Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-oi0-f41.google.com ([209.85.218.41]:34291 "EHLO
	mail-oi0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752061AbaGTLx5 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 20 Jul 2014 07:53:57 -0400
Received: by mail-oi0-f41.google.com with SMTP id a141so2764524oig.14
        for <linux-wireless@vger.kernel.org>; Sun, 20 Jul 2014 04:53:56 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAOiHx=mi0jJQycjJSNjJ3rXrjQEB2N6JP3yg6vqcDN82tZHjzg@mail.gmail.com>
References: <1405854022-11833-1-git-send-email-zajec5@gmail.com>
	<1405854022-11833-2-git-send-email-zajec5@gmail.com>
	<CAOiHx=mi0jJQycjJSNjJ3rXrjQEB2N6JP3yg6vqcDN82tZHjzg@mail.gmail.com>
Date: Sun, 20 Jul 2014 13:53:56 +0200
Message-ID: <CACna6rw=VWjTEmQTeKzWtqhfejFEExnvqHMhWU3hjJ3m0CWGvw@mail.gmail.com> (sfid-20140720_135400_436092_4BCFE721)
Subject: Re: [PATCH 2/2] b43: N-PHY: support setting custom TX power
From: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
To: Jonas Gorski <jogo@openwrt.org>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"John W. Linville" <linville@tuxdriver.com>,
	b43-dev <b43-dev@lists.infradead.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 20 July 2014 13:49, Jonas Gorski <jogo@openwrt.org> wrote:
> On Sun, Jul 20, 2014 at 1:00 PM, Rafał Miłecki <zajec5@gmail.com> wrote:
>> diff --git a/drivers/net/wireless/b43/phy_n.h b/drivers/net/wireless/b43/phy_n.h
>> index 30bec81..252d843 100644
>> --- a/drivers/net/wireless/b43/phy_n.h
>> +++ b/drivers/net/wireless/b43/phy_n.h
>> @@ -967,6 +967,9 @@ struct b43_phy_n {
>>         struct b43_phy_n_txpwrindex txpwrindex[2];
>>         struct b43_phy_n_pwr_ctl_info pwr_ctl_info[2];
>>         struct b43_chanspec txiqlocal_chanspec;
>> +       struct b43_ppr *tx_pwr_max_ppr;
>
> Why not just make this a struct member? As far as I can tell, it will
> always be allocated, and you would lose one alloc/free call, and
> probably one pointer dereference.

My idea was to prevent driver parts from knowing PPR implementation
details. Just to don't mess with its internals and allow redesigning
in the future. That is why I put "struct b43_ppr_rates" in .c file and
all other driver parts use a pointer only.

Seriously, I doubt in the sense of posting RFCs :P

-- 
Rafał

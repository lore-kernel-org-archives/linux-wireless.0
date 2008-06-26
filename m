Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nf-out-0910.google.com ([64.233.182.187]:18105 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755393AbYFZTzt (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 26 Jun 2008 15:55:49 -0400
Received: by nf-out-0910.google.com with SMTP id d3so39156nfc.21
        for <linux-wireless@vger.kernel.org>; Thu, 26 Jun 2008 12:55:48 -0700 (PDT)
Message-ID: <f6ca9fed0806261255n6d421c3fke1d9d50eab3adcd4@mail.gmail.com> (sfid-20080626_215554_042090_02D7F034)
Date: Thu, 26 Jun 2008 21:55:47 +0200
From: drago01 <drago01@gmail.com>
To: "John W. Linville" <linville@tuxdriver.com>
Subject: Re: [PATCH] iwl3945: use rfkill subsystem
Cc: "Johannes Berg" <johannes@sipsolutions.net>,
	"Kolekar, Abhijeet" <abhijeet.kolekar@intel.com>,
	"Linux Wireless" <linux-wireless@vger.kernel.org>,
	"Zhu, Yi" <yi.zhu@intel.com>,
	"Winkler, Tomas" <tomas.winkler@intel.com>,
	"Chatre, Reinette" <reinette.chatre@intel.com>,
	"Dan Williams" <dcbw@redhat.com>
In-Reply-To: <20080626193540.GA28598@tuxdriver.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
References: <f6ca9fed0806160059l58286050wfeb6eda938f3a171@mail.gmail.com>
	 <BD524EA7912ED5469DFD0BAEF6BC752F03D2C277@orsmsx411.amr.corp.intel.com>
	 <1213783675.1312.6.camel@johannes.berg>
	 <20080626193540.GA28598@tuxdriver.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Jun 26, 2008 at 9:35 PM, John W. Linville
<linville@tuxdriver.com> wrote:
> On Wed, Jun 18, 2008 at 12:07:54PM +0200, Johannes Berg wrote:
>> On Tue, 2008-06-17 at 19:34 -0700, Kolekar, Abhijeet wrote:
>> > Added clearing the STATUS_EXIT_PENDING bit while ifup.
>> > ACK.
>> >
>> > The attached patch removes the sysfs interface from iwl3945 and uses
>> > the rfkill subsystem instead.
>>
>> > +++ b/drivers/net/wireless/iwlwifi/iwl3945-base.c
>> > @@ -5913,7 +5913,9 @@ static void __iwl3945_down(struct iwl3945_priv
>> > *priv)
>> >                            test_bit(STATUS_GEO_CONFIGURED,
>> > &priv->status) <<
>> >                                     STATUS_GEO_CONFIGURED |
>> >                            test_bit(STATUS_IN_SUSPEND,
>>
>> That patch is badly mangled by line-wrapping.
>
> Can we have a non-damaged version of this patch?

Seems to be in the iwlwifi-2.6 tree:
http://git.kernel.org/?p=linux/kernel/git/iwlwifi/iwlwifi-2.6.git;a=commitdiff_plain;h=5dc4dfd6165883b6629a48256dc4eadf76d6b65d;hp=042b4c21645d4af2124d7419436ed235c726f400

Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from rn-out-0910.google.com ([64.233.170.189]:62494 "EHLO
	rn-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751067AbYE1OSd (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 28 May 2008 10:18:33 -0400
Received: by rn-out-0910.google.com with SMTP id k40so1609382rnd.17
        for <linux-wireless@vger.kernel.org>; Wed, 28 May 2008 07:18:31 -0700 (PDT)
Message-ID: <1ba2fa240805280718u2ee9232ao487575afeb5938f3@mail.gmail.com> (sfid-20080528_161857_804174_394387F3)
Date: Wed, 28 May 2008 17:18:30 +0300
From: "Tomas Winkler" <tomasw@gmail.com>
To: "Johannes Berg" <johannes@sipsolutions.net>
Subject: Re: [PATCH 1/1] mac80211: sends HT IE to user level through wext
Cc: "Jouni Malinen" <j@w1.fi>, linville@tuxdriver.com,
	yi.zhu@intel.com, linux-wireless@vger.kernel.org,
	"Emmanuel Grumbach" <emmanuel.grumbach@intel.com>
In-Reply-To: <1211980492.21624.11.camel@johannes.berg>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
References: <1211907611-27979-1-git-send-email-tomas.winkler@intel.com>
	 <1211907892.3930.19.camel@johannes.berg>
	 <20080527172032.GN4932@jm.kir.nu>
	 <1211909055.3930.23.camel@johannes.berg>
	 <1ba2fa240805272317t359e79d2xb1913779939ac7c9@mail.gmail.com>
	 <1211980492.21624.11.camel@johannes.berg>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, May 28, 2008 at 4:14 PM, Johannes Berg
<johannes@sipsolutions.net> wrote:
>
>> >> I would prefer to get all IEs in one blob (assuming WEXT does not have
>> >> length limits on this data that could be up to about 2250 bytes long).
>
>> Would this work with current and older version of  wpa_supplicant?.
>> I'm concern with backward compatibility,
>
> Yes, even iwlist handles that fine. In fact, wpa_supplicant simply
> concatenates all of them internally, and iwlist just prints each IE it
> finds in each GENIE item.

One more obstacle

> Actually, we do store them in one blob and then hand out pointers to the
> various parts.

we don't store them as one block we allocate each one separately
(ieee80211_sta_bss) so there will be some bigger rewrite of the code
than this patch, which I'm a bit reluctant to do...time...bugs etc
so what more arguments we have to convince me :)

Thanks
Tomas


>
> johannes
>

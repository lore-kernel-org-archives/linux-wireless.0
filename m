Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wf-out-1314.google.com ([209.85.200.168]:51436 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752027AbZCYBFY (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 24 Mar 2009 21:05:24 -0400
Received: by wf-out-1314.google.com with SMTP id 29so3728744wff.4
        for <linux-wireless@vger.kernel.org>; Tue, 24 Mar 2009 18:05:22 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <loom.20090324T220312-187@post.gmane.org>
References: <1237224184.5027.600.camel@samson.armitage.org.uk>
	<43e72e890903191800y7f30a58fheeb1b8f25eb6d7f2@mail.gmail.com>
	<loom.20090324T220312-187@post.gmane.org>
Date: Tue, 24 Mar 2009 18:05:07 -0700
Message-ID: <43e72e890903241805i464997d3x3da89b3e1584d60a@mail.gmail.com> (sfid-20090325_020528_067581_9C1070D1)
Subject: Re: Oops and other problems in cfg80211
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
To: Quentin Armitage <Quentin@armitage.org.uk>
Cc: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Mar 24, 2009 at 3:18 PM, Quentin Armitage
<Quentin@armitage.org.uk> wrote:
> Luis R. Rodriguez <mcgrof@...> writes:
>
>> > If reg_is_world_roaming is modified to check for last_request not being
>> > NULL, e.g.
>> > if (last_request && last_request->initiator != REGDOM_SET_BY_COUNTRY_IE
>> > &&
>> > then I also get an oops in reg_device_remove where last_request is
>> > referenced and there is only a subsequent check for it being NULL.
> Following the commits included in master-2009-03-23, in function
> reg_device_remove in net/wireless/reg.c there is still a dereference via
> last_request (request_wiphy = wiphy_idx_to_wiphy(last_request->wiphy_idx);)
> prior to the test for last_request != NULL (if (!last_request || !request_wiphy)
> )
> I suspect that following the patches applied, last_request cannot be NULL, and
> therefore the check !last_request is not required; otherwise the check needs to
> be made before the call to wiphy_idx_to_wiphy.
> One way or the other, as it stands the code looks wrong.

Heh yeah its impossible to get that but I'll send a patch. Thanks.

  Luis

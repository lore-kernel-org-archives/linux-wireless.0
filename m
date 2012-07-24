Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-lb0-f174.google.com ([209.85.217.174]:38499 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752235Ab2GXDpT (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 23 Jul 2012 23:45:19 -0400
Received: by lbbgm6 with SMTP id gm6so8686348lbb.19
        for <linux-wireless@vger.kernel.org>; Mon, 23 Jul 2012 20:45:17 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAEFj986CjnbT=j_a7wHvMX9WshjtGD1wttad5iAPM_ViaQhqTg@mail.gmail.com>
References: <1343092554-17734-1-git-send-email-yeohchunyeow@gmail.com>
 <CAG6hwVNnqTBi10vGsjYqYBOedtaThjyJuRt6o=XpZF_dRaqQsA@mail.gmail.com> <CAEFj986CjnbT=j_a7wHvMX9WshjtGD1wttad5iAPM_ViaQhqTg@mail.gmail.com>
From: Julian Calaby <julian.calaby@gmail.com>
Date: Tue, 24 Jul 2012 13:44:57 +1000
Message-ID: <CAGRGNgX6dzeZKeZhECPniWTGoyOymwA9ZB1X7NmTD7pCtTyacg@mail.gmail.com> (sfid-20120724_054521_974867_ED27AA61)
Subject: Re: [PATCH v3] mac80211: add extra checking for RC init upon
 receiving mesh beacon
To: Yeoh Chun-Yeow <yeohchunyeow@gmail.com>
Cc: devel@lists.open80211s.org, Thomas Pedersen <thomas@cozybit.com>,
	johannes@sipsolutions.net, linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Chun-Yeow,

On Tue, Jul 24, 2012 at 1:40 PM, Yeoh Chun-Yeow <yeohchunyeow@gmail.com> wrote:
> Hi, Thomas
>
>>>         sta->last_rx = jiffies;
>>
>> You should avoid duplicating this assignment.
>
> I think that we should also update the sta->last_rx if the
> sta->plink_state is not NL80211_PLINK_ESTAB, am I right?

The point Thomas is making is that this assignment happens both when
the if statement's condition is true and when it's false.

So you could remove it from the if statement and move the one that's
after the if statement above the if statement and the code would be
functionally equivalent and cleaner.

Thanks,

-- 
Julian Calaby

Email: julian.calaby@gmail.com
Profile: http://www.google.com/profiles/julian.calaby/
.Plan: http://sites.google.com/site/juliancalaby/

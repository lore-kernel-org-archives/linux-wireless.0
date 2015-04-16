Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f170.google.com ([209.85.212.170]:37855 "EHLO
	mail-wi0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753473AbbDPJx3 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 16 Apr 2015 05:53:29 -0400
Received: by widdi4 with SMTP id di4so90823786wid.0
        for <linux-wireless@vger.kernel.org>; Thu, 16 Apr 2015 02:53:28 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1429176257.1842.1.camel@sipsolutions.net>
References: <1429161337-32680-1-git-send-email-yeohchunyeow@gmail.com>
	<1429176257.1842.1.camel@sipsolutions.net>
Date: Thu, 16 Apr 2015 17:53:28 +0800
Message-ID: <CAEFj986ZH3mUMNR8O_kzrBhQA2ozFKav46Enc6ru4JUTX=qC7g@mail.gmail.com> (sfid-20150416_115333_008142_745EC031)
Subject: Re: [PATCH] cfg80211: allow the plink state blocking for user managed mesh
From: Yeoh Chun-Yeow <yeohchunyeow@gmail.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	Kalle Valo <kvalo@qca.qualcomm.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Apr 16, 2015 at 5:24 PM, Johannes Berg
<johannes@sipsolutions.net> wrote:
> On Thu, 2015-04-16 at 13:15 +0800, Chun-Yeow Yeoh wrote:
>> User managed peering has no way to block the plink state
>> for mesh peering setup by wpa_supp or authsae. Try to do
>> allow this in kernel space, so that we can use iw utility
>> to do that.
>
> I have no idea what you're trying to say here.
>

wpa_supplicant and authsae allows us to do mesh peering in user space,
but the plink state is still managed in kernel space.

But AFAIK, there is no implementation by wpa_supplicant or authsae to
block the plink state.

By applying this patch, we can use the "iw mesh0 station set
xx:xx:xx:xx:xx:xx plink_action block" to block the peer mesh STA. This
is useful for experimenting purposes.

> johannes
>
> PS: don't CC John any more :)
>

Oops, ok.

----
Chun-Yeow

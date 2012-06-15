Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gg0-f174.google.com ([209.85.161.174]:53402 "EHLO
	mail-gg0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754897Ab2FOJ01 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 15 Jun 2012 05:26:27 -0400
Received: by gglu4 with SMTP id u4so2125891ggl.19
        for <linux-wireless@vger.kernel.org>; Fri, 15 Jun 2012 02:26:26 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1339748416.4512.9.camel@jlt3.sipsolutions.net>
References: <1339691033-13316-1-git-send-email-yeohchunyeow@gmail.com>
	<1339700228.9786.11.camel@jlt3.sipsolutions.net>
	<CAEFj985xi0LNsLqHn1cgAw0oMVsfWrh_ioPuzUva8ZLbUTn=ZQ@mail.gmail.com>
	<1339748416.4512.9.camel@jlt3.sipsolutions.net>
Date: Fri, 15 Jun 2012 17:26:26 +0800
Message-ID: <CAEFj9846z0=Lif42m_Fd4wq3XvS=o_OZ7rTZw2V5gJaHLJ0onA@mail.gmail.com> (sfid-20120615_112631_398617_994F180B)
Subject: Re: [PATCH] mac80211: fix the assignment of mesh element TTL
From: Yeoh Chun-Yeow <yeohchunyeow@gmail.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org, linville@tuxdriver.com,
	devel@lists.open80211s.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi, Johannes

No. I think that I am actually fixing the wrong assignment of the
previous patch.

if (_chg_mesh_attr(NL80211_MESHCONF_ELEMENT_TTL, mask))
     conf->dot11MeshTTL = nconf->element_ttl;
to
     conf->element_ttl = nconf->element_ttl;

Regards,
Chun-Yeow

On Fri, Jun 15, 2012 at 4:20 PM, Johannes Berg
<johannes@sipsolutions.net> wrote:
> On Fri, 2012-06-15 at 08:32 +0800, Yeoh Chun-Yeow wrote:
>> Yes.
>>
>> On Fri, Jun 15, 2012 at 2:57 AM, Johannes Berg
>> <johannes@sipsolutions.net> wrote:
>> > On Fri, 2012-06-15 at 00:23 +0800, Chun-Yeow Yeoh wrote:
>> >> This patch fixes the wrong assignment of mesh element TTL.
>> >
>> > Since I haven't pushed to John yet, should I rebase and merge this with
>> > one of the previous patches?
>
> Umm, I actually shouldn't ... The patch this fixes has been merged by
> John way back:
>
> commit 45904f21655cf4f0ae7d0fab5906fe51bf56ecf4
> Author:     Javier Cardona <javier@cozybit.com>
> AuthorDate: Fri Dec 3 09:20:40 2010 +0100
> Commit:     John W. Linville <linville@tuxdriver.com>
> CommitDate: Mon Dec 6 16:01:28 2010 -0500
>
>    nl80211/mac80211: define and allow configuring mesh element TTL
>
>
> WAY WAY back. Maybe this patch should go into 3.5 and even stable?
>
> johannes
>

Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from an-out-0708.google.com ([209.85.132.249]:39283 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751178AbXJQOT0 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 17 Oct 2007 10:19:26 -0400
Received: by an-out-0708.google.com with SMTP id b36so375257ana
        for <linux-wireless@vger.kernel.org>; Wed, 17 Oct 2007 07:19:25 -0700 (PDT)
Message-ID: <43e72e890710170719o120f9dbak34f33d8218038dfc@mail.gmail.com> (sfid-20071017_151930_299298_646DEF4F)
Date: Wed, 17 Oct 2007 10:19:24 -0400
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
To: "Dan Williams" <dcbw@redhat.com>
Subject: Re: [ath5k-devel] [PATCH 3/3] consistently use ath5k in printks
Cc: "Johannes Berg" <johannes@sipsolutions.net>,
	ath5k-devel@lists.ath5k.org, linux-wireless@vger.kernel.org,
	"John Linville" <linville@tuxdriver.com>
In-Reply-To: <1192630172.10567.29.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
References: <1192540838-26985-1-git-send-email-bruno@thinktube.com>
	 <1192540838-26985-2-git-send-email-bruno@thinktube.com>
	 <1192540838-26985-3-git-send-email-bruno@thinktube.com>
	 <1192540838-26985-4-git-send-email-bruno@thinktube.com>
	 <1192619652.8841.13.camel@johannes.berg>
	 <1192630172.10567.29.camel@localhost.localdomain>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 10/17/07, Dan Williams <dcbw@redhat.com> wrote:
> On Wed, 2007-10-17 at 13:14 +0200, Johannes Berg wrote:
> > On Tue, 2007-10-16 at 22:20 +0900, Bruno Randolf wrote:
> >
> > > the proc interface changed too from /proc/sys/dev/ath/ to /proc/sys/dev/ath5k/
> >
> > Ok, and why exactly is there a proc interface at all?
>
> Yeah, it needs to die, we're not adding new proc interfaces to the
> kernel.  Stuff should be evaluated to see whether it's _really_ needed,
> and if for some reason it is, merged into mac80211 or cfg80211, and then
> if that doesn't work,

Agreed 200%. Die proc usage!

> then maybe something in sysfs.

Nah, configfs for generic configuration of kernel objects. I already
have such module but it just had regdomain support. I plan on adding
add/remove iface.

  Luis

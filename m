Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from py-out-1112.google.com ([64.233.166.178]:45281 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935386AbXJQQ0Z (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 17 Oct 2007 12:26:25 -0400
Received: by py-out-1112.google.com with SMTP id u77so4413772pyb
        for <linux-wireless@vger.kernel.org>; Wed, 17 Oct 2007 09:26:20 -0700 (PDT)
Message-ID: <40f31dec0710170926p3847b796gdf52f80297b7c117@mail.gmail.com> (sfid-20071017_172653_354590_96A3B4E6)
Date: Wed, 17 Oct 2007 19:26:20 +0300
From: "Nick Kossifidis" <mickflemm@gmail.com>
To: "Luis R. Rodriguez" <mcgrof@gmail.com>
Subject: Re: [ath5k-devel] [PATCH 3/3] consistently use ath5k in printks
Cc: "Dan Williams" <dcbw@redhat.com>,
	"Johannes Berg" <johannes@sipsolutions.net>,
	ath5k-devel@lists.ath5k.org, linux-wireless@vger.kernel.org,
	"John Linville" <linville@tuxdriver.com>
In-Reply-To: <43e72e890710170719o120f9dbak34f33d8218038dfc@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
References: <1192540838-26985-1-git-send-email-bruno@thinktube.com>
	 <1192540838-26985-2-git-send-email-bruno@thinktube.com>
	 <1192540838-26985-3-git-send-email-bruno@thinktube.com>
	 <1192540838-26985-4-git-send-email-bruno@thinktube.com>
	 <1192619652.8841.13.camel@johannes.berg>
	 <1192630172.10567.29.camel@localhost.localdomain>
	 <43e72e890710170719o120f9dbak34f33d8218038dfc@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

2007/10/17, Luis R. Rodriguez <mcgrof@gmail.com>:
> On 10/17/07, Dan Williams <dcbw@redhat.com> wrote:
> > On Wed, 2007-10-17 at 13:14 +0200, Johannes Berg wrote:
> > > On Tue, 2007-10-16 at 22:20 +0900, Bruno Randolf wrote:
> > >
> > > > the proc interface changed too from /proc/sys/dev/ath/ to /proc/sys/dev/ath5k/
> > >
> > > Ok, and why exactly is there a proc interface at all?
> >
> > Yeah, it needs to die, we're not adding new proc interfaces to the
> > kernel.  Stuff should be evaluated to see whether it's _really_ needed,
> > and if for some reason it is, merged into mac80211 or cfg80211, and then
> > if that doesn't work,
>
> Agreed 200%. Die proc usage!
>
> > then maybe something in sysfs.
>
> Nah, configfs for generic configuration of kernel objects. I already
> have such module but it just had regdomain support. I plan on adding
> add/remove iface.
>
>   Luis
> -
> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>

I've already removed the whole proc stuff along with debug stuff in
base.c in madwifi-svn, i'll port patch here asap.

-- 
GPG ID: 0xD21DB2DB
As you read this post global entropy rises. Have Fun ;-)
Nick

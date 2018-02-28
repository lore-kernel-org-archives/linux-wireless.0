Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.63.242]:38348 "EHLO
        sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753096AbeB1QB7 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 28 Feb 2018 11:01:59 -0500
Message-ID: <1519833715.2292.2.camel@sipsolutions.net> (sfid-20180228_170441_736213_B9A41BC4)
Subject: Re: [PATCH] mt7601u: remove a warning in
 mt7601u_efuse_physical_size_check()
From: Johannes Berg <johannes@sipsolutions.net>
To: Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
Cc: Jakub Kicinski <kubakici@wp.pl>, linux-wireless@vger.kernel.org
Date: Wed, 28 Feb 2018 17:01:55 +0100
In-Reply-To: <CAJ0CqmU5uii64C2MwCgtFRVzfker4c4G9f5=M3Le8nf+Vkx96A@mail.gmail.com> (sfid-20180228_170124_317316_AE956031)
References: <cover.1519827461.git.lorenzo.bianconi@redhat.com>
         <2850551da4495924bde846dd237b736e41913d0f.1519827461.git.lorenzo.bianconi@redhat.com>
         <1519830361.2292.1.camel@sipsolutions.net>
         <CAJ0CqmU5uii64C2MwCgtFRVzfker4c4G9f5=M3Le8nf+Vkx96A@mail.gmail.com>
         (sfid-20180228_170124_317316_AE956031)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2018-02-28 at 17:01 +0100, Lorenzo Bianconi wrote:
> > On Wed, 2018-02-28 at 15:26 +0100, Lorenzo Bianconi wrote:
> > > 
> > >       const int map_reads = DIV_ROUND_UP(MT_EFUSE_USAGE_MAP_SIZE, 16);
> > > -     u8 data[map_reads * 16];
> > > +     u8 data[round_up(MT_EFUSE_USAGE_MAP_SIZE, 16)];
> > > 
> > 
> > You could turn it upside down and make
> > 
> > const int map_reads = ARRAY_SIZE(data);
> 
> map_reads is actually 2 since MT_EFUSE_USAGE_MAP_SIZE is 29. Using
> ARRAY_SIZE(data) map_reads will be set to 32

Oh yeah, good point, sorry.

johannes

Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:43203 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750799AbYIQXmU (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 17 Sep 2008 19:42:20 -0400
Subject: Re: iw packaging
From: Johannes Berg <johannes@sipsolutions.net>
To: Marcel Holtmann <marcel@holtmann.org>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <1221694596.6782.15.camel@californication>
References: <1221596962.9262.12.camel@johannes.berg>
	 <1221668590.6782.10.camel@californication>
	 <1221669826.3217.1.camel@localhost>
	 (sfid-20080917_184356_807082_BBB4BA6D)  <1221674779.7412.0.camel@localhost>
	 <1221694596.6782.15.camel@californication>
Content-Type: text/plain
Date: Thu, 18 Sep 2008 01:42:09 +0200
Message-Id: <1221694929.7412.24.camel@localhost> (sfid-20080918_014224_515217_85B5FCDE)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2008-09-18 at 01:36 +0200, Marcel Holtmann wrote:
> Hi Johannes,
> 
> > > Do you think it'd be worthwhile? I can probably automate that easily on
> > > wireless.kernel.org...
> > 
> > Since it's trivial, I'm now creating release tarballs for every tag on
> > http://wireless.kernel.org/iw/.
> 
> to make it easier for the packager, I would propose to remove the "v" in
> front of the version number.
> 
> I know you use that for your tags and using git-describe is so great,
> but for packaging the extra character is just in the way.

That's pretty simple. git-describe isn't even involved, this is my
script now:

#!/bin/sh

cd /home/wireless/www/download/iw/
export GIT_DIR=/home/johannes/git/iw.git/

for tag in $(git tag) ; do
        ver=${tag#v}
        archive=iw-$ver.tar.bz2
        if test -f $archive ; then
                continue
        fi
        git-archive --format=tar --prefix=iw-$ver/ $tag | bzip2 > $archive
done


johannes


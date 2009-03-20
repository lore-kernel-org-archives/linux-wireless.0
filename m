Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:36941 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752762AbZCTIYw (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 20 Mar 2009 04:24:52 -0400
Subject: Re: nl80211 data prior to nested attributes funky
From: Johannes Berg <johannes@sipsolutions.net>
To: "Luis R. Rodriguez" <mcgrof@gmail.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	pat-lkml <pat-lkml@erley.org>
In-Reply-To: <43e72e890903191805x19344034w2bb8be34a9000a89@mail.gmail.com> (sfid-20090320_020540_946048_35E7FC12)
References: <43e72e890903191805x19344034w2bb8be34a9000a89@mail.gmail.com>
	 (sfid-20090320_020540_946048_35E7FC12)
Content-Type: text/plain
Date: Fri, 20 Mar 2009 09:24:46 +0100
Message-Id: <1237537486.5100.128.camel@johannes.local> (sfid-20090320_092456_185228_EF5AEDBD)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2009-03-19 at 18:05 -0700, Luis R. Rodriguez wrote:
> If you try to rename a wiphy multiple times with iw you will get
> something like this:
> 
> wiphy rename: phy #1 to 2
> wiphy rename: phy #1 to 3

I don't see any error?

# iw phy phy0 set name falafel
# iw phy falafel set name guacamole
# iw phy guacamole set name phy1
command failed: Invalid argument (-22)
# iw phy guacamole set name phy0

where I will get in iw event:

$ iw event
wiphy rename: phy #0 to falafel
wiphy rename: phy #0 to guacamole
wiphy rename: phy #0 to phy0

were you expecting the old name, rather than the index?

johannes


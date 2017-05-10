Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:59174 "EHLO sipsolutions.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752213AbdEJKoe (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 10 May 2017 06:44:34 -0400
Message-ID: <1494413071.5482.5.camel@sipsolutions.net> (sfid-20170510_124437_761466_C697CE35)
Subject: Re: [PATCH] mac80211: Validate michael MIC before attempting packet
 decode.
From: Johannes Berg <johannes@sipsolutions.net>
To: mike@hellotwist.com
Cc: linux-wireless@vger.kernel.org
Date: Wed, 10 May 2017 12:44:31 +0200
In-Reply-To: <CAKXXJEzWfNrQxquCzA5dkD5=xCXWyeAC+_yBT35N1oDk-H_Buw@mail.gmail.com> (sfid-20170509_201632_574132_3ABEEF43)
References: <CAKXXJEzWfNrQxquCzA5dkD5=xCXWyeAC+_yBT35N1oDk-H_Buw@mail.gmail.com>
         (sfid-20170509_201632_574132_3ABEEF43)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2017-05-09 at 14:16 -0400, Michael Skeffington wrote:
> In order to allow wpa_supplicant to correctly identify a perceived
> WPA TKIP key
> recovery attack the michael MIC must be checked before the packet
> decode is
> attempted.  A packet with an invalid MIC will always fail a decrypt
> check which
> previously was being checked first.  Therefore the MIC failure bit of
> status flags
> describing the error would remain unset.

This isn't how the Michael MIC works. I have no idea what problem
you're trying to solve, but this is not the solution.

johannes

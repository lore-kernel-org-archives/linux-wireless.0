Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.62]:53220 "EHLO
        sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727772AbeISRqv (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 19 Sep 2018 13:46:51 -0400
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH 0/7] netlink recursive policy validation
Date: Wed, 19 Sep 2018 14:08:53 +0200
Message-Id: <20180919120900.28708-1-johannes@sipsolutions.net> (sfid-20180919_140946_949394_5F70870F)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This series adds recursive policy validation, allowing you to specify
complex policies involving nested attributes, both
 * attributes that directly contain new nested attributes
   (NLA_NESTED)
 * attributes that have nested attributes used as an array, where the
   type of each inner attribute is irrelevant/ignored but each of them
   yet again contains nested attributes that should conform to a given
   policy (the new NLA_NESTED_ARRAY)

This is useful for a more compact representation of the policy for the
attributes, which - among other benefits - makes it more easily seen
when reading the code, requiring reading just the policy instead of
digging into all the usage/nested validation code.

In terms of code benefits, it means possibly some validation code can
be removed.

One thing to be aware of: retrofitting this to existing policies may
in fact break userspace - it might have been sending broken but ignored
attributes, which global enforcement of the (nested) policy would now
prevent.

johannes

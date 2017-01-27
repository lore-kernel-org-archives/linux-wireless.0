Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtprelay0124.hostedemail.com ([216.40.44.124]:41474 "EHLO
        smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1750839AbdA0VKo (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 27 Jan 2017 16:10:44 -0500
Message-ID: <1485551440.12563.140.camel@perches.com> (sfid-20170127_221559_304269_BC8CD9AE)
Subject: Re: [PATCH] cfg80211 debugfs: Cleanup some checkpatch issues
From: Joe Perches <joe@perches.com>
To: Johannes Berg <johannes@sipsolutions.net>,
        Pichugin Dmitry <smokeman85@gmail.com>, davem@davemloft.net
Cc: linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Date: Fri, 27 Jan 2017 13:10:40 -0800
In-Reply-To: <1485550820.14579.2.camel@sipsolutions.net>
References: <20170127192603.GA13522@gmail.com>
         (sfid-20170127_203712_578214_221D21FF) <1485550820.14579.2.camel@sipsolutions.net>
Content-Type: text/plain; charset="ISO-8859-1"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2017-01-27 at 22:00 +0100, Johannes Berg wrote:
> On Fri, 2017-01-27 at 22:26 +0300, Pichugin Dmitry wrote:
> > This fixes the checkpatch.pl warnings:
> > * Macros should not use a trailing semicolon.
> > * Spaces required around that '='.
> > * Symbolic permissions 'S_IRUGO' are not preferred.
> > * Macro argument reuse 'buflen' - possible side-effects
> 
> I really see no point in any of this.

Look at the uses of DEBUGFS_READONLY_FILE and
see if they are consistent before and after.

 DEBUGFS_READONLY_FILE(rts_threshold, 20, "%d",
-                     wiphy->rts_threshold)
+                     wiphy->rts_threshold);
 DEBUGFS_READONLY_FILE(fragmentation_threshold, 20, "%d",
                      wiphy->frag_threshold);
 DEBUGFS_READONLY_FILE(short_retry_limit, 20, "%d",
-                     wiphy->retry_short)
+                     wiphy->retry_short);
 DEBUGFS_READONLY_FILE(long_retry_limit, 20, "%d",
                      wiphy->retry_long);

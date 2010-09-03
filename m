Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:25349 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751420Ab0ICM7G (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 3 Sep 2010 08:59:06 -0400
Date: Fri, 3 Sep 2010 14:55:29 +0200
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Wey-Yi Guy <wey-yi.w.guy@intel.com>,
	Reinette Chatre <reinette.chatre@intel.com>,
	"John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org
Subject: Re: [PATCH 0/13] iwlwifi: rewrite iwl-scan.c to avoid race conditions
Message-ID: <20100903125528.GA2629@redhat.com>
References: <1283515056-11523-1-git-send-email-sgruszka@redhat.com>
 <1283516518.4700.5.camel@jlt3.sipsolutions.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1283516518.4700.5.camel@jlt3.sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Sep 03, 2010 at 02:21:58PM +0200, Johannes Berg wrote:
> On Fri, 2010-09-03 at 13:57 +0200, Stanislaw Gruszka wrote:
> 
> [lots of patches]
> 
> Looks OK to me, apart from what I've pointed out,

All concerns are fixed by later patches.

> and I hope you've
> tested it :-) I'm not an expert on the scanning code, to be honest.

I used below script on iwl3945. I plan to make some more testing, on
iwlagn and with different scenarios. But patches improve things, it was
easy to reproduce problem with script on iwl3945, with patches problem
seems to gone.

#!/bin/bash

export my_dev=`iw dev | grep Interface | head -1 | awk '{ print $2 }'`
export my_phy=`iw dev | grep phy  | head -1 | tr -d '#'`

(while true; do iwlist ${my_dev} scan ; sleep 3 ; done) &
b1=$!
(while true; do ifconfig ${my_dev} down ; ifconfig $my_dev up ; sleep 8 ; done) &
b2=$!

mount -t debugfs debugfs /sys/kernel/debug 2> /dev/null > /dev/null

(while true; do echo 1 > /sys/kernel/debug/ieee80211/${my_phy}/iwl3945/debug/force_reset ; sleep 5 ; done ) &
b3=$!
(while true; do echo 0 > /sys/kernel/debug/ieee80211/${my_phy}/iwl3945/debug/force_reset ; sleep 13 ; done ) &
b4=$!

function exit_script ()
{
	kill -KILL $b1
	kill -KILL $b2
	kill -KILL $b3
	kill -KILL $b4
	kill -KILL $$
}

trap exit_script INT TERM EXIT

while true ; do sleep 1 ; done

exit_script

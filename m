Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wm0-f45.google.com ([74.125.82.45]:33677 "EHLO
	mail-wm0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751845AbcCATbh (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 1 Mar 2016 14:31:37 -0500
Received: by mail-wm0-f45.google.com with SMTP id l68so50358327wml.0
        for <linux-wireless@vger.kernel.org>; Tue, 01 Mar 2016 11:31:37 -0800 (PST)
Date: Tue, 1 Mar 2016 20:31:34 +0100
From: Thomas Graf <tgraf@suug.ch>
To: Bob Copeland <me@bobcopeland.com>
Cc: linux-wireless@vger.kernel.org,
	Johannes Berg <johannes@sipsolutions.net>,
	netdev@vger.kernel.org
Subject: Re: [PATCH RFC 1/2] rhashtable: accept GFP flags in
 rhashtable_walk_init
Message-ID: <20160301193134.GA11309@pox.localdomain> (sfid-20160301_203141_709391_92E1ADDA)
References: <1456708013-19590-1-git-send-email-me@bobcopeland.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1456708013-19590-1-git-send-email-me@bobcopeland.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 02/28/16 at 08:06pm, Bob Copeland wrote:
> In certain cases, the 802.11 mesh pathtable code wants to
> iterate over all of the entries in the forwarding table from
> the receive path, which is inside an RCU read-side critical
> section.  Enable walks inside atomic sections by allowing
> GFP_ATOMIC allocations for the walker state.
> 
> Change all existing callsites to pass in GFP_KERNEL.
> 
> Cc: Thomas Graf <tgraf@suug.ch>
> Cc: netdev@vger.kernel.org
> Signed-off-by: Bob Copeland <me@bobcopeland.com>

rhashtable bits LGTM

Acked-by: Thomas Graf <tgraf@suug.ch>

Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtprelay0130.hostedemail.com ([216.40.44.130]:56349 "EHLO
        smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1751014AbdIAGPY (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 1 Sep 2017 02:15:24 -0400
Message-ID: <1504246520.2361.3.camel@perches.com> (sfid-20170901_081631_378871_3CBAFDF6)
Subject: Re: [PATCH 1/2] iwlwifi: fix long debug print
From: Joe Perches <joe@perches.com>
To: Luca Coelho <luca@coelho.fi>, kvalo@codeaurora.org
Cc: linux-wireless@vger.kernel.org,
        Liad Kaufman <liad.kaufman@intel.com>
Date: Thu, 31 Aug 2017 23:15:20 -0700
In-Reply-To: <1504244238.31031.24.camel@coelho.fi>
References: <20170825082730.31388-1-luca@coelho.fi>
         <20170825082730.31388-2-luca@coelho.fi>
         <1504216665.2786.48.camel@perches.com>
         <1504244238.31031.24.camel@coelho.fi>
Content-Type: text/plain; charset="ISO-8859-1"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2017-09-01 at 08:37 +0300, Luca Coelho wrote:
> On Thu, 2017-08-31 at 14:57 -0700, Joe Perches wrote:
> > On Fri, 2017-08-25 at 11:27 +0300, Luca Coelho wrote:
> > > From: Liad Kaufman <liad.kaufman@intel.com>
> > > 
> > > There is a debug print that sometimes reaches over
> > > 110 chars, thus generating a warning in those cases.
> > 
> > What emits a warning here?
> 
> We have a WARN_ON in iwl-devtrace-msg.h:
> 
> #define MAX_MSG_LEN	110

OK, thanks for the hint.

The commit message is a bit obscure.

It might make sense to add a comment to describe these
trace events coming from TRACE_EVENT(iwlwifi_dbg,

All the IWL_DEBUG_<foo> use this trace message maximum.

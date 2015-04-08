Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtprelay0041.hostedemail.com ([216.40.44.41]:35365 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751629AbbDHLtO (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 8 Apr 2015 07:49:14 -0400
Date: Wed, 8 Apr 2015 07:49:10 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: Arend van Spriel <arend@broadcom.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
	<linux-wireless@vger.kernel.org>
Subject: Re: [PATCH] brcmsmac: Move each system tracepoints to their own
 header
Message-ID: <20150408074910.7563a1c8@gandalf.local.home> (sfid-20150408_134931_660768_25EFDD4E)
In-Reply-To: <5524D99C.1050902@broadcom.com>
References: <20150407121148.17207bd8@gandalf.local.home>
	<5524D99C.1050902@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 8 Apr 2015 09:32:44 +0200
Arend van Spriel <arend@broadcom.com> wrote:

> On 04/07/15 18:11, Steven Rostedt wrote:
> >
> > Every tracing file must have its own TRACE_SYSTEM defined.
> > The brcmsmac tracepoint header broke this and added in the middle
> > of the file:
> >
> >   #undef TRACE_SYSTEM
> >   #define TRACE_SYSTEM brcmsmac
> >
> >   #undef TRACE_SYSTEM
> >   #define TRACE_SYSTEM brcmsmac_tx
> >
> >   #undef TRACE_SYSTEM
> >   #define TRACE_SYSTEM brcmsmac_msg
> >
> > Unfortunately, this broke new code in the ftrace infrastructure.
> > Moving each of these TRACE_SYSTEMs into their own trace file with
> > just one TRACE_SYSTEM per file fixes the issue.
> >
> > Cc: Arend van Spriel<arend@broadcom.com>
> 
> All right. Go ahead and change Cc: into Acked-by:
> 

Thanks!

-- Steve

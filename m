Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fmailhost05.isp.att.net ([207.115.11.55]:59351 "EHLO
	fmailhost05.isp.att.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758824AbZDHOto (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 8 Apr 2009 10:49:44 -0400
Message-ID: <49DCB976.4020200@lwfinger.net> (sfid-20090408_164949_029739_E441033F)
Date: Wed, 08 Apr 2009 09:49:26 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: Rusty Russell <rusty@rustcorp.com.au>
CC: Arjan van de Ven <arjan@linux.intel.com>,
	LKML <linux-kernel@vger.kernel.org>,
	"Rafael J. Wysocki" <rjw@sisk.pl>,
	wireless <linux-wireless@vger.kernel.org>
Subject: Re: Regression in 2.6.30-rc1 since commit acae0515 - wireless broken
References: <49DC2DF5.3010603@lwfinger.net> <49DC31EA.8050208@linux.intel.com> <200904081631.09150.rusty@rustcorp.com.au>
In-Reply-To: <200904081631.09150.rusty@rustcorp.com.au>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Rusty Russell wrote:
> On Wednesday 08 April 2009 14:41:06 Arjan van de Ven wrote:
>> Larry Finger wrote:
>>> The most recent pulls of the Linux-2.6 git tree has broken wireless. The problem
>>> was bisected with commit acae05156551fd7528fbb616271e672789388e3c, entitled
>>> "module: create a request_module_nowait()", indicated as the faulty change. This
>>> is seen with driver b43 on my system, and 2 reports for driver iwlagn:
>>> http://marc.info/?l=linux-wireless&m=123916157630571&w=2 and
>>> http://marc.info/?l=linux-wireless&m=123913015021457&w=2.
>>>
>>> For b43, the logged error messages are:
>> rusty... I still suspect your "int to bool" conversion stuff ;-)
> 
> One way to find out.  Here's the reversion:
> 
> diff --git a/include/linux/kmod.h b/include/linux/kmod.h
> --- a/include/linux/kmod.h
> +++ b/include/linux/kmod.h
> @@ -29,12 +29,10 @@
>  #ifdef CONFIG_MODULES
>  /* modprobe exit status on success, -ve on error.  Return value
>   * usually useless though. */
> -extern int __request_module(bool wait, const char *name, ...) \

The patch did not fix the problem. The symptoms are the same.

Larry

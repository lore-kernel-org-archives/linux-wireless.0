Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from youngberry.canonical.com ([91.189.89.112]:47822 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752143Ab2KSVdF (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 19 Nov 2012 16:33:05 -0500
Date: Mon, 19 Nov 2012 15:33:00 -0600
From: Seth Forshee <seth.forshee@canonical.com>
To: Arend van Spriel <arend@broadcom.com>
Cc: linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>,
	"Franky (Zhenhui) Lin" <frankyl@broadcom.com>,
	Brett Rudley <brudley@broadcom.com>,
	Roland Vossen <rvossen@broadcom.com>,
	Kan Yan <kanyan@broadcom.com>, brcm80211-dev-list@broadcom.com,
	Daniel Wagner <wagi@monom.org>
Subject: Re: [PATCH v2 09/22] brcm80211: Allow trace support to be enabled
 separately from debug
Message-ID: <20121119213300.GC20301@thinkpad-t410> (sfid-20121119_223309_604851_30296A5D)
References: <1352988492-21340-1-git-send-email-seth.forshee@canonical.com>
 <1352988492-21340-10-git-send-email-seth.forshee@canonical.com>
 <50AA9789.9070807@broadcom.com>
 <20121119211511.GB20301@thinkpad-t410>
 <50AAA275.5030609@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <50AAA275.5030609@broadcom.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Nov 19, 2012 at 10:19:49PM +0100, Arend van Spriel wrote:
> On 11/19/2012 10:15 PM, Seth Forshee wrote:
> >On Mon, Nov 19, 2012 at 09:33:13PM +0100, Arend van Spriel wrote:
> >>On 11/15/2012 03:07 PM, Seth Forshee wrote:
> >>>Since the runtime overhead of trace support is small when tracing is
> >>>disabled, users may be interested in turning on trace support while
> >>>leaving other debug features off. Add a new config option named
> >>>CONFIG_BRCM_TRACING for this purpose.
> >>
> >>Reviewed-by: Pieter-Paul Giesberts <pieterpg@broadcom.com>
> >>Reviewed-by: Arend van Spriel
> >>>Signed-off-by: Seth Forshee <seth.forshee@canonical.com>
> >>>---
> >>>  drivers/net/wireless/brcm80211/Kconfig             |   11 +++++++++++
> >>>  .../brcm80211/brcmsmac/brcms_trace_events.h        |    6 +++---
> >>>  2 files changed, 14 insertions(+), 3 deletions(-)
> >>>
> >>>diff --git a/drivers/net/wireless/brcm80211/Kconfig b/drivers/net/wireless/brcm80211/Kconfig
> >>>index c9d811e..3735c27 100644
> >>>--- a/drivers/net/wireless/brcm80211/Kconfig
> >>>+++ b/drivers/net/wireless/brcm80211/Kconfig
> >>>@@ -63,6 +63,17 @@ config BRCMISCAN
> >>>  	  new E-Scan method which uses less memory in firmware and gives no
> >>>  	  limitation on the number of scan results.
> >>>
> >>>+config BRCM_TRACING
> >>>+	bool "Broadcom device tracing"
> >>>+	depends on BRCMSMAC || BRCMFMAC
> >>>+	---help---
> >>>+	  If you say Y here, the Broadcom wireless drivers will register
> >>>+	  with ftrace to dump event information into the trace ringbuffer.
> >>>+	  Tracing can be enabled at runtime to aid in debugging wireless
> >>>+	  issues. This option adds a small amount of overhead when tracing
> >>>+	  is disabled. If unsure, say Y to allow developers to better help
> >>>+	  you when wireless problems occur.
> >>>+
> >>
> >>I regard this as a debugging feature. Did you consider making it
> >>depend on BRCMDBG instead? Or do you think that BRCMDBG code would
> >>affect run-time behavior during tracing.
> >
> >It is a debugging feature, but making it depend on BRCMDBG prevents my
> >intended use case. I'm planning to enable BRCM_TRACING in Ubuntu and to
> >leave BRCMDBG disabled. This will make it easy for us to ask users for
> >detailed debug information when needed with minimal overhead during
> >normal use.
> 
> That seems reasonable. Have you any significant impact in throughput
> with tracing enabled?

I've really only tested with tracing enabled. Compared to before this
patch series the peak performance (as measured with iperf using a TCP
connection) is close enough that any differences would be lost in the
noise, and average performance is better due to the transfer rate being
more stable. I'll run some tests with and without tracing enabled to
compare the results. I may not get to it before next week though due to
the Thanksgiving holiday here in the US.

Seth


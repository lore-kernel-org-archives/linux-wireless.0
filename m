Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:8116 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756436AbXJOJVN convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 15 Oct 2007 05:21:13 -0400
MIME-Version: 1.0
Subject: RE: [ipw3945-devel] [PATCH] [PATCH] mac80211: honorIW_SCAN_THIS_ESSID in siwscan ioctl
Date: Mon, 15 Oct 2007 11:20:11 +0200
Message-ID: <C07C4589BE74A34981C3C3525EE1F80102A8EEAE@hasmsx412.ger.corp.intel.com> (sfid-20071015_102118_511046_D9E6F072)
In-Reply-To: <200710121525.25574.hschaa@suse.de>
From: "Winkler, Tomas" <tomas.winkler@intel.com>
To: "Helmut Schaa" <hschaa@suse.de>,
	"John W. Linville" <linville@tuxdriver.com>
Cc: <dcbw@redhat.com>, <linux-wireless@vger.kernel.org>,
	<ipw3945-devel@lists.sourceforge.net>,
	"Bill Moss" <bmoss@clemson.edu>
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

You are, we will provide a patch to fix that.
Thanks.
Tomas

>-----Original Message-----
>From: ipw3945-devel-bounces@lists.sourceforge.net
[mailto:ipw3945-devel-
>bounces@lists.sourceforge.net] On Behalf Of Helmut Schaa
>Sent: Friday, October 12, 2007 3:25 PM
>To: John W. Linville
>Cc: dcbw@redhat.com; linux-wireless@vger.kernel.org; ipw3945-
>devel@lists.sourceforge.net; Bill Moss
>Subject: Re: [ipw3945-devel] [PATCH] [PATCH] mac80211:
>honorIW_SCAN_THIS_ESSID in siwscan ioctl
>
>Hi,
>
>Am Mittwoch, 10. Oktober 2007 22:34:56 schrieb John W. Linville:
>> This patch fixes the problem of associating with wpa_secured hidden
>> AP.  Please try out.
>
>The patch did not fix the issue for _some_ APs I have here but it is
>apparently correct.
>
>I was able to track the issue further down to the probe-request iwlwifi
>sends
>to connect to a hidden AP (hw_scan is enabled). Attached is a quick
hack
>against iwlwifi-1.1.0 which made hidden AP working for me (using
hw_scan).
>
>The patch is only ment as a hint, not as a real fix!
>
>The problem seemed to be in the info element "supported rates". The
>probe-request mac80211 would generate does only attach eight supported
>rates
>to this info element, the rest goes to "extended supported rates".
>
>Instead iwlwifi puts _all_ (more then eight) rates into "supported
rates"
>and
>omits "extended supported rates". As "supported rates" is specified in
>802.11b there should only be 802.11b rates (this is an assumption as I
do
>not
>have the 802.11 specs here). This is exactly what my patch does: limit
the
>number of supported rates to eight.
>
>Can somebody please verify if I'm right?
>
>Btw iwlwifi generates the probe-request itself _only_ if hw_scan is
>enabled.
>If hw_scan is disabled mac80211 generates the probe-request (which then
>should be correct) but the request gets somehow corrupted.
>
>Thanks,
>Helmut
---------------------------------------------------------------------
Intel Israel (74) Limited

This e-mail and any attachments may contain confidential material for
the sole use of the intended recipient(s). Any review or distribution
by others is strictly prohibited. If you are not the intended
recipient, please contact the sender and delete all copies.

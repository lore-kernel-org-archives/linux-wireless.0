Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:21381 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759386AbYGBHFB (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 2 Jul 2008 03:05:01 -0400
Subject: Question on rfkill double block
From: Zhu Yi <yi.zhu@intel.com>
To: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Date: Wed, 02 Jul 2008 15:03:28 +0800
Message-Id: <1214982208.14590.473.camel@debian.sh.intel.com> (sfid-20080702_090507_076203_C9C59295)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

Quote from Documentation/rfkill.txt:
"
The driver should implement the toggle_radio() hook, that:

=2E..

3. Deactivates the soft rfkill line if none of the hardware rfkill line=
s
are active and the caller asked for RFKILL_STATE_UNBLOCKED.
"

It doesn't say what to do if both the hardware and software rfkill line=
s
are active when RFKILL_STATE_UNBLOCKED is asked. Should we deactivate
the software rfkill in this case? Otherwise below usage won't turn on
the radio:

hardware rfkill activate
software rfkill activate
RFKILL_STATE_UNBLOCKED request
hardware rfkill deactivate

=46urthermore, if we permit double block, what should get_state() retur=
n?
Shouldn't rfkill_state =EF=BB=BFbe bitmap instead of enum?

Thanks,
-yi

--
To unsubscribe from this list: send the line "unsubscribe linux-wireles=
s" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

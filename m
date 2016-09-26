Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:10292 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1754976AbcIZIKO (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 26 Sep 2016 04:10:14 -0400
From: "Sharon, Sara" <sara.sharon@intel.com>
To: 'Kalle Valo' <kvalo@codeaurora.org>, Luca Coelho <luca@coelho.fi>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "Coelho, Luciano" <luciano.coelho@intel.com>
Subject: RE: [PATCH 10/25] iwlwifi: mvm: support packet injection
Date: Mon, 26 Sep 2016 08:10:08 +0000
Message-ID: <84271B8B681983469E84120965EB1B0434D68BCA@HASMSX106.ger.corp.intel.com> (sfid-20160926_101021_017353_E9B6EB3A)
References: <1474270071.5664.89.camel@coelho.fi>
        <20160919073028.22065-10-luca@coelho.fi>
 <87oa3d1r5h.fsf@kamboji.qca.qualcomm.com>
In-Reply-To: <87oa3d1r5h.fsf@kamboji.qca.qualcomm.com>
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

> The commit log doesn't tell a lot. I started to wonder why use debugfs and not the proper interface through mac80211?

This is RX packet injection, not TX. So the injection goes up - from the driver to mac80211.
Since we use it to test some mvm data path stuff, we don't want to inject at mac80211 level.

> But reading from the code makes me suspect that this isn't really normal packet injection, more like passing full descriptors to the hw. Did I understand correctly?

For injecting at driver level we need the injected packet to contain a fake of the HW descriptor for the driver processing.
This descriptor isn't being passed to the hw, but to the driver since it is RX.
The code isn't creating the descriptor, but it is validating length and other checks to make sure we won't access invalid memory or so.

Sara
---------------------------------------------------------------------
A member of the Intel Corporation group of companies

This e-mail and any attachments may contain confidential material for
the sole use of the intended recipient(s). Any review or distribution
by others is strictly prohibited. If you are not the intended
recipient, please contact the sender and delete all copies.

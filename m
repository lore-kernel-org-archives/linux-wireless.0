Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.63.242]:52244 "EHLO
        sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753135AbeADOsw (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 4 Jan 2018 09:48:52 -0500
Message-ID: <1515077330.10342.25.camel@sipsolutions.net> (sfid-20180104_154856_168171_A69F8CFC)
Subject: Re: [PATCH v2 2/3] nl80211: Allow SAE Authentication for
 NL80211_CMD_CONNECT
From: Johannes Berg <johannes@sipsolutions.net>
To: Jouni Malinen <jouni@qca.qualcomm.com>
Cc: linux-wireless@vger.kernel.org,
        Srinivas Dasari <dasaris@qti.qualcomm.com>
Date: Thu, 04 Jan 2018 15:48:50 +0100
In-Reply-To: <1513960419-24780-2-git-send-email-jouni@qca.qualcomm.com>
References: <1513960419-24780-1-git-send-email-jouni@qca.qualcomm.com>
         <1513960419-24780-2-git-send-email-jouni@qca.qualcomm.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2017-12-22 at 18:33 +0200, Jouni Malinen wrote:
> From: Srinivas Dasari <dasaris@qti.qualcomm.com>
> 
> This commit allows SAE Authentication for NL80211_CMD_CONNECT
> interface, provided this is supported by the host driver.

Now this is interesting - there could potentially be a case where you
request SAE, but don't set NL80211_ATTR_EXTERNAL_AUTH_SUPP[ORT], and
then SAE *isn't* supported, right?

What happens then? Do we expect the driver to reject it? Better at
least document the expected behaviour...

johannes

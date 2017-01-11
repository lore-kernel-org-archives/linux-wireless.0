Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:32854 "EHLO sipsolutions.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1757358AbdAKN0K (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 11 Jan 2017 08:26:10 -0500
Message-ID: <1484141166.29931.8.camel@sipsolutions.net> (sfid-20170111_142612_493918_A41558C3)
Subject: Re: [PATCH 3/3] cfg80211: Specify the reason for connect timeout
From: Johannes Berg <johannes@sipsolutions.net>
To: "Malinen, Jouni" <jouni@qca.qualcomm.com>,
        Arend Van Spriel <arend.vanspriel@broadcom.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "Kushwaha, Purushottam" <pkushwah@qti.qualcomm.com>
Date: Wed, 11 Jan 2017 14:26:06 +0100
In-Reply-To: <20170111131335.GB27748@jouni.qca.qualcomm.com>
References: <1483984388-30237-1-git-send-email-jouni@qca.qualcomm.com>
         <1483984388-30237-3-git-send-email-jouni@qca.qualcomm.com>
         <a59ef282-921d-6591-ab33-0a8dd3ef4294@broadcom.com>
         <20170111131335.GB27748@jouni.qca.qualcomm.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2017-01-11 at 13:13 +0000, Malinen, Jouni wrote:
> 
> > > @@ -172,6 +174,7 @@ static int cfg80211_conn_do_work(struct
> > > wireless_dev *wdev)
> > >  	case CFG80211_CONN_AUTH_FAILED:
> > > +		*treason = NL80211_TIMEOUT_AUTH;
> > 
> > ... but it seems AUTH failure always is a timeout?
> 
> The CFG80211_CONN_AUTH_FAILED case is currently used only in
> cfg80211_sme_auth_timeout() which is indeed always a timeout.

Might be worth simply renaming it, since you have the reason there
unconditionally?

johannes

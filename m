Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.63.242]:47704 "EHLO
        sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751161AbdKMJZq (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 13 Nov 2017 04:25:46 -0500
Message-ID: <1510565141.30497.6.camel@sipsolutions.net> (sfid-20171113_102745_502374_8FC7C108)
Subject: Re: [PATCH] mac80211: Update last_ack status for all except probing
 frames
From: Johannes Berg <johannes@sipsolutions.net>
To: Rajkumar Manoharan <rmanohar@qti.qualcomm.com>,
        Igor Mitsyanko <igor.mitsyanko.os@quantenna.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "rmanohar@codeaurora.org" <rmanohar@codeaurora.org>
Date: Mon, 13 Nov 2017 10:25:41 +0100
In-Reply-To: <96799d352b7347a8a9092bb37f1cd8d9@NALASEXR01H.na.qualcomm.com>
References: <1509409746-26592-1-git-send-email-rmanohar@qti.qualcomm.com>
         <1509964164.2669.0.camel@sipsolutions.net>
         <8bb232d231884f9595c81f945a5eef4f@NALASEXR01H.na.qualcomm.com>
         <49241af7-a50f-5758-0c7e-77f2fae5d93d@quantenna.com>
         <96799d352b7347a8a9092bb37f1cd8d9@NALASEXR01H.na.qualcomm.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2017-11-06 at 20:20 +0000, Rajkumar Manoharan wrote:
> > > For steering an idle station from one BSS to another, the steering
> > > application has to know the actual station idle period. But if the
> > > idle period is cleared by ap_max_inactivity, the steering application
> > > cannot steer the station even though the station is not sending or receiving
> > 
> > any data or mgmt. frame.

I guess you want something else. Why even consider a station that's
sending mgmt frames as non-idle?

You can just use the data TX/RX counters to figure out if the station
has been idle.

You've not convinced me that changing the current logic here makes any
sense.

johannes

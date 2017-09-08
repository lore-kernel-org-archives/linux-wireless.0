Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:33048 "EHLO sipsolutions.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1754560AbdIHKMf (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 8 Sep 2017 06:12:35 -0400
Message-ID: <1504865553.6177.20.camel@sipsolutions.net> (sfid-20170908_121340_315983_C63A6CF1)
Subject: Re: [PATCH 2/2] wireless: return correct mandatory rates
From: Johannes Berg <johannes@sipsolutions.net>
To: Richard =?ISO-8859-1?Q?Sch=FCtz?= <rschuetz@uni-koblenz.de>,
        linux-wireless@vger.kernel.org
Cc: Simon Wunderlich <sw@simonwunderlich.de>
Date: Fri, 08 Sep 2017 12:12:33 +0200
In-Reply-To: <f9e34cbf-e0e1-3faa-39dd-58ad6968d276@uni-koblenz.de>
References: <20170907154744.28357-1-rschuetz@uni-koblenz.de>
         <20170907154744.28357-2-rschuetz@uni-koblenz.de>
         <1504853740.6177.10.camel@sipsolutions.net>
         <5aed0ea0-f127-bd1e-ca06-db7edbf56680@uni-koblenz.de>
         <1504861413.6177.16.camel@sipsolutions.net>
         <f9e34cbf-e0e1-3faa-39dd-58ad6968d276@uni-koblenz.de>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2017-09-08 at 12:10 +0200, Richard Schütz wrote:
> 
> This would leave us with 1, 2, 5.5 and 11 Mb/s for ERP PHYs again
> when it really should be 1, 2, 5.5, 6, 11, 12 and 24 Mb/s.
> 

Yes, you're right - I had thought about that but forgot. The places
that check it would have to be amended to check both HR_DSSS and OFDM
where they want ERP PHY operation.

johannes

Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qc0-f180.google.com ([209.85.216.180]:47814 "EHLO
	mail-qc0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755325Ab3CNQ0Z (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 14 Mar 2013 12:26:25 -0400
Received: by mail-qc0-f180.google.com with SMTP id v28so1083611qcm.39
        for <linux-wireless@vger.kernel.org>; Thu, 14 Mar 2013 09:26:24 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <477F20668A386D41ADCC57781B1F70430D9D9C2199@SC-VEXCH1.marvell.com>
References: <CAMLZHHS_G3N+UcKqPBWr6JPTWADCNOgdXReL8s3q3GPpYebGvQ@mail.gmail.com>
	<477F20668A386D41ADCC57781B1F70430D9D6CE59E@SC-VEXCH1.marvell.com>
	<477F20668A386D41ADCC57781B1F70430D9D6CE6CD@SC-VEXCH1.marvell.com>
	<CAMLZHHRmd+Yfr_72HdfNd+knPJg8KvuAA2WrC0TC0wQ8pOeMeA@mail.gmail.com>
	<477F20668A386D41ADCC57781B1F70430D9D6CE95B@SC-VEXCH1.marvell.com>
	<CAMLZHHR+OCQd_2J8NkmK0CND9vo6VaT73L+rJKJRk7bUknh7Qw@mail.gmail.com>
	<477F20668A386D41ADCC57781B1F70430D9D6CEC9D@SC-VEXCH1.marvell.com>
	<477F20668A386D41ADCC57781B1F70430D9D9C1608@SC-VEXCH1.marvell.com>
	<CAMLZHHQyTDHD8q=Q-edSew+KnpaGWOaVwxiK_fjABG9ZC9g-Qg@mail.gmail.com>
	<477F20668A386D41ADCC57781B1F70430D9D9C2199@SC-VEXCH1.marvell.com>
Date: Thu, 14 Mar 2013 10:26:24 -0600
Message-ID: <CAMLZHHQYB8wYEq1gppNEMiV0BPfM3qKtujR4=4u1jVww-N6z5w@mail.gmail.com> (sfid-20130314_172629_297255_0B07517A)
Subject: Re: mwifiex crash when removing interface while scanning
From: Daniel Drake <dsd@laptop.org>
To: Bing Zhao <bzhao@marvell.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	John Rhodes <jrhodes@marvell.com>,
	Amitkumar Karwar <akarwar@marvell.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Mar 12, 2013 at 9:04 PM, Bing Zhao <bzhao@marvell.com> wrote:
> Tim Shepard reported a scan timeout issue back in kernel 3.5 when NetworkManager is enabled, and he had a HACK workaround for that. I wonder if this is the same issue in 3.8.
> Could you please try that workaround again?

That seems to avoid the issue. I'm worried that it suggests some more
significant lower-level bug, but I guess for now it would make sense
to finish off those 2 patches you already posted, and investigate the
possible cmd_pending leak, before revisiting this.

Thanks.
Daniel

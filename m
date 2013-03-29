Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qa0-f42.google.com ([209.85.216.42]:41096 "EHLO
	mail-qa0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755425Ab3C2Nq3 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 29 Mar 2013 09:46:29 -0400
Received: by mail-qa0-f42.google.com with SMTP id bv4so2059938qab.8
        for <linux-wireless@vger.kernel.org>; Fri, 29 Mar 2013 06:46:28 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <477F20668A386D41ADCC57781B1F70430D9DCBEBB7@SC-VEXCH1.marvell.com>
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
	<CAMLZHHQYB8wYEq1gppNEMiV0BPfM3qKtujR4=4u1jVww-N6z5w@mail.gmail.com>
	<477F20668A386D41ADCC57781B1F70430D9DAD3AE4@SC-VEXCH1.marvell.com>
	<477F20668A386D41ADCC57781B1F70430D9DAD430D@SC-VEXCH1.marvell.com>
	<CAMLZHHRmyftv4sz+jmozJoAjvRTP-4DF-59C6N22R7tccCJ5WQ@mail.gmail.com>
	<477F20668A386D41ADCC57781B1F70430D9DCBEBB7@SC-VEXCH1.marvell.com>
Date: Fri, 29 Mar 2013 07:46:28 -0600
Message-ID: <CAMLZHHT92u7gAGyfnqo_4S=+MgmEu0iW0bCbQ1jPycuRWf_6fQ@mail.gmail.com> (sfid-20130329_144632_734311_4851BEB2)
Subject: Re: mwifiex crash when removing interface while scanning
From: Daniel Drake <dsd@laptop.org>
To: Bing Zhao <bzhao@marvell.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	John Rhodes <jrhodes@marvell.com>,
	Amitkumar Karwar <akarwar@marvell.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Mar 27, 2013 at 8:24 PM, Bing Zhao <bzhao@marvell.com> wrote:
> This is caused by decreasing cmd_pending while cleanup scan commands in scan_pending_q.
> cmd_pending only counts the commands queued in cmd_pending_q.
>
> Attached v2 patch should fix it. Please try it out.

Thanks, applied both patches, that seems to be working now.

Daniel

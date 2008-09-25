Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fg-out-1718.google.com ([72.14.220.156]:25517 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752863AbYIYKpb (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 25 Sep 2008 06:45:31 -0400
Received: by fg-out-1718.google.com with SMTP id 19so260274fgg.17
        for <linux-wireless@vger.kernel.org>; Thu, 25 Sep 2008 03:45:30 -0700 (PDT)
Message-ID: <1ba2fa240809250345n89d2dcehd7bb3474eab777de@mail.gmail.com> (sfid-20080925_124536_421653_240B401B)
Date: Thu, 25 Sep 2008 13:45:30 +0300
From: "Tomas Winkler" <tomasw@gmail.com>
To: "John W. Linville" <linville@tuxdriver.com>
Subject: Re: [PATCH 1/1] iwlwifi 2.6.27: send all the calibration results instead of the last one only
Cc: johannes@sipsolutions.net, yi.zhu@intel.com,
	linux-wireless@vger.kernel.org,
	"Emmanuel Grumbach" <emmanuel.grumbach@intel.com>
In-Reply-To: <20080924191634.GB3639@tuxdriver.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
References: <1222128868-16763-1-git-send-email-tomas.winkler@intel.com>
	 <20080924191634.GB3639@tuxdriver.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Sep 24, 2008 at 10:16 PM, John W. Linville
<linville@tuxdriver.com> wrote:
> On Tue, Sep 23, 2008 at 03:14:28AM +0300, Tomas Winkler wrote:
>> From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
>>
>> This patch solves a bug in calibration. We get three results from the
>> initial microcode, but we freed all the results upon each reception leading
>> to zero two of them, only the last one survived. This fix is user visible in
>> HT rates.
>>
>> This patch simplifed version for 2.6.27 and will create conflict with
>> 86316f2fe474b019cc445211980f5394977b34d5 iwlwifi: generic init calibrations framework
>
> The code is different in wireless-next-2.6.  Does this problem exist there?

Oh sorry for confusion, the proper fix is
86316f2fe474b019cc445211980f5394977b34d5
but it was said it's too much code for 2.6.27 so this patch was to
address that and is minimal as possible.. If this is not in 2.6.27
just drop it.

Thanks
Tomas

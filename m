Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wa-out-1112.google.com ([209.85.146.182]:6721 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753264AbYFMI25 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 13 Jun 2008 04:28:57 -0400
Received: by wa-out-1112.google.com with SMTP id j37so3217461waf.23
        for <linux-wireless@vger.kernel.org>; Fri, 13 Jun 2008 01:28:56 -0700 (PDT)
Message-ID: <1ba2fa240806130128l433c5b3fxfc7ff13c886a2fa1@mail.gmail.com> (sfid-20080613_102909_364958_30420705)
Date: Fri, 13 Jun 2008 11:28:56 +0300
From: "Tomas Winkler" <tomasw@gmail.com>
To: "Johannes Berg" <johannes@sipsolutions.net>
Subject: Re: [PATCH 1/3] iwlwifi: adding channels to sysfs
Cc: "Zhu Yi" <yi.zhu@intel.com>, linville@tuxdriver.com,
	linux-wireless@vger.kernel.org,
	"Ester Kummer" <ester.kummer@intel.com>
In-Reply-To: <1213343813.3860.0.camel@johannes.berg>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
References: <1213343095-8133-1-git-send-email-yi.zhu@intel.com>
	 <1213343095-8133-2-git-send-email-yi.zhu@intel.com>
	 <1213343813.3860.0.camel@johannes.berg>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Jun 13, 2008 at 10:56 AM, Johannes Berg
<johannes@sipsolutions.net> wrote:
> On Fri, 2008-06-13 at 15:44 +0800, Zhu Yi wrote:
>> From: Ester Kummer <ester.kummer@intel.com>
>>
>> This patch returns channel list to sysfs.
>>
>> Signed-off-by: Ester Kummer <ester.kummer@intel.com>
>> Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
>> Signed-off-by: Zhu Yi <yi.zhu@intel.com>
>> ---
>>  drivers/net/wireless/iwlwifi/iwl4965-base.c |   58 ++++++++++++++++++++++++++-
>>  1 files changed, 56 insertions(+), 2 deletions(-)
>>
>> diff --git a/drivers/net/wireless/iwlwifi/iwl4965-base.c b/drivers/net/wireless/iwlwifi/iwl4965-base.c
>> index 81a1c22..c179b21 100644
>> --- a/drivers/net/wireless/iwlwifi/iwl4965-base.c
>> +++ b/drivers/net/wireless/iwlwifi/iwl4965-base.c
>> @@ -4122,8 +4122,62 @@ static DEVICE_ATTR(power_level, S_IWUSR | S_IRUSR, show_power_level,
>>  static ssize_t show_channels(struct device *d,
>>                            struct device_attribute *attr, char *buf)
>>  {
>> -     /* all this shit doesn't belong into sysfs anyway */
>> -     return 0;
>
> Hehe. Do you really have to? You can query this information with
> nl80211. I don't know why you need all that sysfs stuff anyway.

I'm not sure why Yi has cut off the log message but original was

'This patch returns channel list to sysfs. This is requirement
for validation purposes'

Our automation is build around sysfs and wext and I'm not going to
rewrite it now.

Tomas

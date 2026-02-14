Received: from dispatch1-us1.ppe-hosted.com (dispatch1-us1.ppe-hosted.com [67.231.154.184])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1EF701A9FBC
	for <linux-wireless@vger.kernel.org>; Sat, 14 Feb 2026 17:18:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=67.231.154.184
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771089516; cv=none; b=uezKlJV7jtFaOxr77WPJGwUspNE51nkuEVWwJKoPTAb46CUcDkCi3IwpBlkNosJJJ8cehC0wtJh8aaYiozHASLDgdUafG30Y1YiX8FPCdrxVrnwuN7O3MIKy5+kcwu5KiVzOKoEmblbudNyK5t1ADfCS2zh4OXRRyH3G6rznGaw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771089516; c=relaxed/simple;
	bh=8t78IH3icv5a80MUrTJ8CwQO6OpIRjdqWZeEDOoKp/4=;
	h=Message-ID:Date:MIME-Version:To:Cc:From:Subject:Content-Type; b=MqnLl65TCxpEyr2KW4MArZIWcAMBcDVqweCp3GzayI/f/u/P63mlH5iKusqUw2L37fMYtLP+dSw7drKFL4d+d5PQXO3V8WfXtaYsTHTtqlhpNeE2FbeZyDOH0zwGQBiGnrTVoiJRlGrkAVXYdSrCF+AvCaTQJjwe3jm7npW5dHE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=candelatech.com; spf=pass smtp.mailfrom=candelatech.com; dkim=pass (1024-bit key) header.d=candelatech.com header.i=@candelatech.com header.b=BcSk2UCq; arc=none smtp.client-ip=67.231.154.184
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=candelatech.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=candelatech.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=candelatech.com header.i=@candelatech.com header.b="BcSk2UCq"
Received: from dispatch1-us1.ppe-hosted.com (ip6-localhost [127.0.0.1])
	by dispatch1-us1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTP id DC2063103AA
	for <linux-wireless@vger.kernel.org>; Sat, 14 Feb 2026 17:11:58 +0000 (UTC)
X-Virus-Scanned: Proofpoint Essentials engine
Received: from mail3.candelatech.com (mail.candelatech.com [208.74.158.173])
	by mx1-us1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTP id 37859C0008F;
	Sat, 14 Feb 2026 17:11:51 +0000 (UTC)
Received: from [192.168.1.23] (unknown [98.97.32.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by mail3.candelatech.com (Postfix) with ESMTPSA id A7B5813C2B0;
	Sat, 14 Feb 2026 09:11:46 -0800 (PST)
DKIM-Filter: OpenDKIM Filter v2.11.0 mail3.candelatech.com A7B5813C2B0
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=candelatech.com;
	s=default; t=1771089108;
	bh=8t78IH3icv5a80MUrTJ8CwQO6OpIRjdqWZeEDOoKp/4=;
	h=Date:To:Cc:From:Subject:From;
	b=BcSk2UCqKQEdAnHOsT2KJvaqVfTJbLMzGQWoBoexUSNe3ydppYGCz3l5qTjABsoPd
	 uOsWeua9vR/uhewaRn2Qb30safru+efdUz9nGWhGYBZK+n73YrES3X3xyy7xYTkS/e
	 03qiSjV1kG+VVKXlWuUlwdVLlMZu8kvxKWWYAIok=
Message-ID: <5ffe48af-e02d-4d02-b669-6a9d6797b956@candelatech.com>
Date: Sat, 14 Feb 2026 09:11:43 -0800
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Content-Language: en-MW
To: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Cc: Miri Korenblit <miriam.rachel.korenblit@intel.com>
From: Ben Greear <greearb@candelatech.com>
Subject: iwlmld iwl_mld_change_vif_links can return un-initilized 'err'
Organization: Candela Technologies
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-MDID: 1771089111-qwjmy7gbdITO
X-PPE-STACK: {"stack":"us5"}
X-MDID-O:
 us5;at1;1771089111;qwjmy7gbdITO;<greearb@candelatech.com>;b05365583a7ac22983513582f8b41fd7
X-PPE-TRUSTED: V=1;DIR=OUT;

Hello,

I believe this method:

static int
iwl_mld_change_vif_links(struct ieee80211_hw *hw,

Can return un-initialized 'err' in case that this return path is taken:

	if (WARN_ON(!iwl_mld_error_before_recovery(mld)))
		return err;

I saw this warning hit, and then later kernel crashed with some debugfs
dentry being bogus, but not sure that is actually related.

Probably err should be initialized to -EINVAL at top of the method.

Thanks,
Ben

-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com

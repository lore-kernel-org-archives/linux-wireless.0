Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 76C1C3C0A11
	for <linux-wireless@vger.kernel.org>; Sat, 17 Oct 2026 08:04:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792224298; cv=none; b=QURiqFCWMup2PVyPIKXeaKqi+cOiP4CL+AZ50h4cpea+Q8k/cfc8O2x0+oG5wqg7EkwANWt3dh75fqWgaBwzSGM3z1j0EPvc4CBqs6cicFO69DsDzb+7lzt2MjZM/+xxTQsLBZSZ8weT/NiBXuN9D93Of4o1NM5iF9vAdE4lrWo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792224298; c=relaxed/simple;
	bh=T2X/NPxw04NLeBqwlBxu8Ew5YcEVhywK9NUgebHkghc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=mLx5u+NQqAYcWm6VUxMOcFDjNGendKGTmfUY3xB59x7hcAYfISWZ1g9RRr3Mh5nJLJEFsY3dFOv23T24PTGWvHm6OKmpAOXYYeRc7nkKNBwG5abXeuzAwq95qZTW37GmQNo1HlazRdfrXlZ9EgykP7LtH17dOGkXEykw9WzpaqI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=dWsA2Eos; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="dWsA2Eos"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1792224296;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=T2X/NPxw04NLeBqwlBxu8Ew5YcEVhywK9NUgebHkghc=;
	b=dWsA2EoslZftoepJCpjxatEe62F/KDn3iV308QZc9gGbdWEctHpHX5yCGi10FqHrb/Eo5p
	dLHxPGHQgJJ71nT0xW+RmQoX2yB9V8cFzJaiTXy+qDsEmjHgZpSDvtvnXTiEN6dUP31M9W
	pm/KJUegfMXtp23YxjPvUd935nW316U=
Received: from mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-687-VoMmkkY7OiqWdZUZTVk1sw-1; Sat,
 17 Oct 2026 08:04:51 +0000
X-MC-Unique: VoMmkkY7OiqWdZUZTVk1sw-1
X-Mimecast-MFC-AGG-ID: VoMmkkY7OiqWdZUZTVk1sw_1792224289
Received: from mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.17])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id C9FEA19560B4;
	Sat, 17 Oct 2026 08:04:48 +0000 (UTC)
Received: from jtornosm-thinkpadp1gen7.rmtes.csb (headnet05.pony-001.prod.iad2.dc.redhat.com [10.2.32.117])
	by mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id E9AB91956087;
	Sat, 17 Oct 2026 08:04:45 +0000 (UTC)
From: Jose Ignacio Tornos Martinez <jtornosm@redhat.com>
To: baochen.qiang@oss.qualcomm.com
Cc: ath11k@lists.infradead.org,
	ath12k@lists.infradead.org,
	jjohnson@kernel.org,
	johannes@sipsolutions.net,
	jtornosm@redhat.com,
	linux-kernel@vger.kernel.org,
	linux-wireless@vger.kernel.org
Subject: Re: [PATCH v2 1/3] wifi: ath12k: fixes to improve MLO station stability
Date: Sat, 17 Oct 2026 10:04:43 +0200
Message-ID: <20261017080444.41177-1-jtornosm@redhat.com>
In-Reply-To: <aaf175a7-86e0-4da2-a3fc-df87d906f800@oss.qualcomm.com>
References: <aaf175a7-86e0-4da2-a3fc-df87d906f800@oss.qualcomm.com>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.17

Hi Baochen,

I agree that per-callback guards don't scale well long-term. Johannes
can comment better because both alternatives need mac80211 changes,
but let me share my thoughts.

Option 1 (recovery inside .start()) holds rtnl for ~1.3s, that seems
too long to hold.

Option 2 (split ieee80211_restart_hw() into early barrier + deferred
restart) looks like the right direction. It would benefit any driver
with async recovery, not just ath12k. But it is a mac80211 core change
and a bigger effort, and it still needs in_reconfig checks added to
callbacks that don't have them today (scan, for one), so the guarding
moves to mac80211 rather than disappearing.

In the meantime, the crashes this series fixes are real: without it,
an MLO firmware crash gives NULL derefs and 20+ second recovery. The
guards here cover the callbacks that actually run during that window,
not a speculative list.

I am happy to work on the mac80211 side (option 2), but would it make
sense for you to land this series as an interim fix while that is
worked out as a follow-up?

Thanks

Best regards
José Ignacio

